            CMD        Prompt('Send Request')
            PARM       KWD(FILEA) TYPE(*CHAR) LEN(128) +
                       PROMPT('File to compare 1') ALWUNPRT(*NO)
            PARM       KWD(FILEB) TYPE(*CHAR) LEN(128) +
                       PROMPT('File to compare 2') ALWUNPRT(*NO)
            PARM       KWD(ULX) TYPE(*INT4) +
                       PROMPT('Upper left x coord(in points)')
            PARM       KWD(ULY) TYPE(*INT4) +
                       PROMPT('Upper left Y coord(in points)')
            PARM       KWD(LRX) TYPE(*INT4) +
                       PROMPT('Lower right x coord(in points)')
            PARM       KWD(LRY) TYPE(*INT4) +
                       PROMPT('Lower right y coord(in points)')
            PARM       KWD(STATUS) TYPE(*DEC) LEN(5) RTNVAL(*YES) +
                       PROMPT('Status code from server (out)')
            PARM       KWD(STATUSCD) TYPE(*CHAR) LEN(100) RTNVAL(*YES) +
                       PROMPT('Status description (out)')
