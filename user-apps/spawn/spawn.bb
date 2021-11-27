SUMMARY = "Usr space app to span in two procs, wait on them, and two spawned procs die only upon getting SIGINT"
DESCRIPTION = "${SUMMARY}"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=12f884d2ae1ff87c09e5b7ccc2c4ca7e"

SRC_URI = "file://spawn.c \
           file://COPYING \
          "

S = "${WORKDIR}"

exe_name = "spawn"

do_compile () {
	${CC} ${CFLAGS} ${LDFLAGS} ${WORKDIR}/spawn.c -o ${WORKDIR}/${exe_name}
}

do_install () {
    install -d ${D}${USRBINPATH}
	install -m 0777 ${WORKDIR}/${exe_name} ${D}${USRBINPATH}/${exe_name}
}

RPROVIDES_${PN} += "spawn"
