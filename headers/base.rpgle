        Dcl-Pr BASE EXTPGM;
          pType     Char(5);
          pEndpoint Char(128);
          pHeader   Char(2048) CCSID(1208);
          pBody     Pointer;
          oStatus   Packed(5)     Options(*NoPass);
        End-Pr;
