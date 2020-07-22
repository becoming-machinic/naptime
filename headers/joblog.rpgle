        dcl-pr writeJobLog int(10) extproc('Qp0zLprintf');
          *n pointer value options(*string); // logMsg
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
          *n pointer value options(*string:*nopass);
        end-pr;

        dcl-c joblogCRLF const(x'25');