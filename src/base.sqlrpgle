        
        Ctl-Opt Copyright('Becoming Machinic 2019');

        /INCLUDE './headers/base.rpgle'
        /INCLUDE './headers/joblog.rpgle'

        Dcl-Pi BASE;
          pType     Char(5);
          pEndpoint Char(128);
          pHeader   Char(2048) CCSID(1208);
          pBody     Pointer; //Points to SQL clob
          oStatus   Packed(5)   Options(*NoPass);
        End-Pi;

        //We have to do this disgusting thing because
        //the SQL precompiler removes the based keyword
        //when the SQLTYPE type is used. Slight bug.
       
        Dcl-S Req_Header SQLTYPE(CLOB:1208);
        Dcl-Ds Req_Body_p Qualified based(pBody);
          REQ_BODY_LEN UNS(10);
          REQ_BODY_DATA CHAR(5242880) CCSID(1208);
        End-Ds;
        Dcl-S Req_Body SQLTYPE(CLOB:5242880);

        Dcl-Ds RequestData Qualified;
          URL    Varchar(128);
          Status Varchar(5);
        End-Ds;

        Dcl-S HasStatus Ind;
        Dcl-S BodyNull Int(5);
        Dcl-S HeadNull Int(5);
        Dcl-S Nullind BINDEC(4);
        Dcl-S chHeader   Char(2048) CCSID(37);
        
          
		 
		 
         Dcl-S Options varchar(100);
    
        Req_Body = Req_Body_p;
		
        
	      HasStatus = (%Parms >= %ParmNum(oStatus));

        RequestData.URL = %Trim(pEndpoint);
        Req_Header_Len  = %Len(pHeader) / 2;
        Req_Header_Data = pHeader;
				
        Select;

          When (pTYPE = '*GET');
            EXEC SQL 
              SELECT IFNULL(RESPONSEMSG,'-'), 
                     IFNULL(RESPONSEHTTPHEADER, '-')
              INTO :Req_Body, :Req_Header
              FROM TABLE(SYSTOOLS.HTTPGETCLOBVERBOSE
                (:RequestData.URL, :Req_Header)) AS HTTPDATA;

          When (pTYPE = '*POST');
            EXEC SQL 
              SELECT RESPONSEMSG, RESPONSEHTTPHEADER 
              INTO :Req_Body :BodyNull, :Req_Header :HeadNull 
              FROM TABLE(SYSTOOLS.HTTPPOSTCLOBVERBOSE(
                :RequestData.URL, :Req_Header, 
                :Req_Body 
              )) 
              AS HTTPDATA;    

        Endsl;

        //Get the status code out
        If (HasStatus);
           chHeader = Req_Header_Data;
		
          
           EXEC SQL
            SELECT *
            INTO :RequestData.Status
            FROM XMLTABLE(
              '$doc/httpHeader' PASSING XMLPARSE(DOCUMENT
               cast(:chHeader as char(2048) CCSID 1208)) 			  
                as "doc"
              COLUMNS
                Value VARCHAR(5) PATH '@responseCode'
            ) HeaderResponse;

          If (RequestData.Status = *Blanks);
            RequestData.Status = '503';
          Endif;
          
          oStatus = %Dec(RequestData.Status:5:0);
          writeJobLog('* Status code: ' + RequestData.Status + '%s':joblogCRLF);
        Endif;

        pHeader = Req_Header_Data;
        Req_Body_p.REQ_BODY_LEN  = Req_Body_Len;
        Req_Body_p.REQ_BODY_DATA = Req_Body_Data;

        Return;
