CC=gcc

# Comment these out to disable PNG output if no PNG lib is available.
#
# Devcpp has static packages for libpng, libz, and glut so use them.  Need -lgdi though.
#PNG_FLAGS=-DUSE_PNG -I./win
#PNG_LIBS=-L./win -lpng -lz
#
PNG_FLAGS=-DUSE_PNG
PNG_LIBS= -static -lpng -lz

# Comment these out to disable tile rendering option.
#
TR_FLAGS=-DTILE_RENDER_OPTION
TR_SRC=tr.c

# UnComment this to build in support for Mesa Offscreen rendering
OFFSCREEN_FLAGS=-DWIN_DIB_OPTION
OFFSCREEN_LIBS= -lgdi32

# Comment these out to disable the test GUI made with MUI.
#
# Define both MUI and GLUT to access the MUI GUI via the GLUT menu.
#GUI_FLAGS=-DTEST_MUI_GUI -I./mui/include -DUSE_GLUT_MENUS
GUI_FLAGS=-DTEST_MUI_GUI -I./mui/include
GUI_SRC=ldglgui.c
GUI_LIBS=-L./mui/lib/mui -lmui
LIBS = libmui.a

RES_SRC=ldglite.rc

# NOTE: -mwindows makes it detach from the console.
#       This is good for gui apps but bad if launched from dos
#       because we lose stdin.  Perhaps I should make 2 versions
#       or make it a makefile option.
#
#  -DWINTIMER -DUNDEFINED_SWAP_TEST -DSAVE_DEPTH_ALL
#
#  -DNOT_WARPING -DVISIBLE_SPIN_CURSOR
#
CFLAGS=-ggdb -DUSE_OPENGL -DUSE_L3_PARSER -DUSE_BMP8 $(PNG_FLAGS) $(TR_FLAGS) $(OFFSCREEN_FLAGS) $(GUI_FLAGS)
#CFLAGS=-ggdb -DUSE_OPENGL -DUSE_L3_PARSER -DUSE_BMP8 $(PNG_FLAGS) $(TR_FLAGS) $(OFFSCREEN_FLAGS) $(GUI_FLAGS) -mwindows

AR = ar
RANLIB = ranlib

SRCS = ldliteVR_main.c platform.c dirscan.c gleps.c camera.c f00QuatC.c quant.c stub.c lcolors.c y.tab.c lex.yy.c qbuf.c main.c ldglpr.c L3Edit.c L3Math.c L3Input.c L3View.c hoser.c ldglmenu.c plugins.c $(TR_SRC) $(GUI_SRC) 
OBJS = $(SRCS:.c=.o) $(RES_SRC:.rc=.o)

all	: ldglite

ldglite:   $(OBJS) $(LIBS)
	$(CC) $(CFLAGS) $(OBJS) -o ldglite.exe -I. $(PNG_LIBS) $(OFFSCREEN_LIBS) $(GUI_LIBS) -lglut32 -lglu32 -lopengl32 -lwinmm -lgdi32
	cp ldglite.exe l3glite.exe
	cp ldglite.exe l3gledit.exe

libmui.a:
	if [ -d mui/lib/mui ] ; then cd mui/lib/mui ; $(MAKE) -f Makefile $@ ; fi

l3glite:   ldglite

ldglitepng:   ldglite

l3glitepng:   ldglite

ldglite.o: ldglite.rc
	windres -i ldglite.rc -o ldglite.o

clean:
	rm *.o
