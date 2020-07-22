BIN_LIB=NAPTIME
PROD_LIB=MACHINIC

SYSTEM=-s

all: naptime machinic
	@echo Build complete.

naptime: BIN_LIB=NAPTIME
naptime: base.pgm sendreq.pgm sendreq.cmdobj

machinic: BIN_LIB=MACHINIC
machinic: duppdfchk.pgm duppdfchk.pnl duppdfchk.cmdobj statuses.sql

%.pgm: %.mod
	system $(SYSTEM) "CRTPGM PGM($(BIN_LIB)/$*)"
	@touch $@

%.mod: src/%.sqlrpgle
	system $(SYSTEM) "CHGATR OBJ('$<') ATR(*CCSID) VALUE(1252)"
	system $(SYSTEM) "CRTSQLRPGI OBJ($(BIN_LIB)/$*) SRCSTMF('$<') COMMIT(*NONE) OBJTYPE(*MODULE) DBGVIEW(*SOURCE)"
	@touch $@

%.pnl: src/%.pnl
	-system -i "CRTSRCPF FILE($(BIN_LIB)/QPNLSRC) RCDLEN(112)"
	system $(SYSTEM) "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QPNLSRC.file/$*.mbr') MBROpT(*REPLACE)"
	system $(SYSTEM) "CRTPNLGRP PNLGRP($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QPNLSRC) SRCMBR($*)"
	@touch $@


%.cmdobj: src/%.cmd
	-system -i "CRTSRCPF FILE($(BIN_LIB)/QCMDSRC) RCDLEN(112)"
	system $(SYSTEM) "CPYFRMSTMF FROMSTMF('$<') TOMBR('/QSYS.lib/$(BIN_LIB).lib/QCMDSRC.file/$*.mbr') MBROpT(*REPLACE)"
	system $(SYSTEM) "CRTCMD CMD($(BIN_LIB)/$*) PGM($(BIN_LIB)/$*) SRCFILE($(BIN_LIB)/QCMDSRC) HLPPNLGRP($*) HLPID(*CMD) ALLOW(*BPGM *IPGM *IREXX *BREXX)"
	@touch $@
	
%.sql: src/%.sql
	system "RUNSQLSTM SRCSTMF('$<') COMMIT(*NONE)"	
	@touch $@

clean:
	rm -rf *.cmd *.cmdobj *.pgm *.pnl *.sql

savf:
	-mkdir release
	@echo " -- Creating $(BIN_LIB).savf --"
	system "CRTSAVF FILE($(BIN_LIB)/$(BIN_LIB))"
	system "SAVLIB LIB($(BIN_LIB)) DEV(*SAVF) SAVF($(BIN_LIB)/$(BIN_LIB)) OMITOBJ((RELEASE *FILE))"
	system "CPYTOSTMF FROMMBR('/QSYS.lib/$(BIN_LIB).lib/$(BIN_LIB).FILE') TOSTMF('./release/$(BIN_LIB).savf') STMFOPT(*REPLACE) STMFCCSID(1252) CVTDTA(*NONE)"
	system "DLTOBJ OBJ($(BIN_LIB)/$(BIN_LIB)) OBJTYPE(*FILE)"
	
	@echo " -- Creating $(PROD_LIB).savf --"
	system "CRTSAVF FILE($(PROD_LIB)/$(PROD_LIB))"
	system "SAVLIB LIB($(PROD_LIB)) DEV(*SAVF) SAVF($(PROD_LIB)/$(PROD_LIB)) OMITOBJ((RELEASE *FILE))"
	system "CPYTOSTMF FROMMBR('/QSYS.lib/$(PROD_LIB).lib/$(PROD_LIB).FILE') TOSTMF('./release/$(PROD_LIB).savf') STMFOPT(*REPLACE) STMFCCSID(1252) CVTDTA(*NONE)"
	system "DLTOBJ OBJ($(PROD_LIB)/$(PROD_LIB)) OBJTYPE(*FILE)"
	@echo " -- Release created! --"
	@echo ""
	@echo "To install the release, run:"
	@echo "  > CRTLIB $(BIN_LIB)"
	@echo "  > CPYFRMSTMF FROMSTMF('./release/$(BIN_LIB).savf') TOMBR('/QSYS.lib/$(BIN_LIB).lib/$(BIN_LIB).FILE') MBROPT(*REPLACE) CVTDTA(*NONE)"
	@echo "  > RSTLIB SAVLIB($(BIN_LIB)) DEV(*SAVF) SAVF($(BIN_LIB)/$(BIN_LIB))"
	@echo ""
