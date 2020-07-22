            CMD        Prompt('Send Request')
            PARM       KWD(TYPE) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                       DFT(*GET) VALUES(*GET *POST) PROMPT('Type')
            PARM       KWD(URL) TYPE(*CHAR) LEN(128) +
                       PROMPT('Endpoint') ALWUNPRT(*NO)
            PARM       KWD(HEADER) TYPE(*CHAR) LEN(2048) +
                       PROMPT('Header') ALWUNPRT(*NO) 
            PARM       KWD(BODY) TYPE(*CHAR) LEN(16384) +
                       PROMPT('Body') ALWUNPRT(*NO) 
            PARM       KWD(STATUS) TYPE(*DEC) LEN(5) +
                       PROMPT('Status code')