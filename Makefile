#######################################APPLICATION##################################################
################################################################################################
########################################MACROS##################################################
################################################################################################
#$(1)
#$(2)   Object file to generate
#$(3)   Source file
#$(4)   Additional dependencies
#$(5)   Compiler flags
define COMPILE
$(2) : $(3) $(4)
	$(1) -c -o $(2) $(3) $(5)
endef
#$(1)   Source file
#$(1)   src/tinyPTC/xbcde.cpp
#$(1)   obj/tinyPTC/xbcde.o
define C2O
$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(patsubst $(SRC)%,$(OBJ)%,$(1))))
endef
#$(1) Source file
define C2H
$(patsubst %.c,%.h,$(patsubst %.cpp,%.hpp,$(1)))
endef
################################################################################################
################################################################################################
################################################################################################v
APP         := app
CFLAGS     := -Wall -pedantic
CCFLAGS     	:= $(CFLAGS) -std=c++17
CC          := g++
C			:= gcc
MKDIR       := mkdir -p
SRC         := src
OBJ         := obj
LIBDIR := lib
LIBS	:= $(LIBDIR)/tinyPTC/libtinyptc.a
LIBS += $(LIBDIR)/picoPNG/libpicopng.a
LIBS += -Wall -pedantic
INCDIRS := -I$(SRC) -I$(LIBDIR)
LIBS		+= -lX11 -lXext


#para el uso commando es make DEBUG=1
ifdef DEBUG 
	CCFLAGS += -g
else
	CCFLAGS += -O3
endif


ALLCPPS 	:= $(shell find src/ -type f -iname *.cpp)
#ALLOCPPSOBJ  	:= $(patsubst %.cpp,%.o,$(ALLCPPS))
ALLCS		:= $(shell find src/ -type f -iname *.c)
#ALLCSOBJ	:= $(patsubst %.c,%.o,$(ALLCS))
SUBDIRS 	:= $(shell find $(SRC) -type d)
OBJSUBDIRS 	:= $(patsubst $(SRC)%,$(OBJ)%,$(SUBDIRS))
ALLOBJ 		:= $(foreach F,$(ALLCPPS) $(ALLCS),$(call C2O,$(F)))

.PHONY: info libs libs-clean libs-cleanall
#Generate APP
$(APP) : $(OBJSUBDIRS) $(ALLOBJ)
	$(CC) -o $(APP) $(ALLOBJ) $(LIBS)

#Generate rules for all objects



$(foreach F,$(ALLCPPS),$(eval $(call COMPILE,$(CC),$(call C2O,$(F)),$(F),$(call C2H$(F)),$(CCFLAGS) $(INCDIRS))))
$(foreach F,$(ALLCS),$(eval $(call COMPILE,$(C),$(call C2O,$(F)),$(F),$(call C2H$(F)),$(CFLAGS) $(INCDIRS))))



#%.o : %.c
#	$(C) -o $(patsubst $(SRC)%,$(OBJ)%,$@) -c $^ $(CFLAGS)

#%.o : %.cpp
#	$(CC) -o $(patsubst $(SRC)%,$(OBJ)%,$@) -c $^ $(CCFLAGS)

info:
	$(info $(SUBDIRS))
	$(info $(OBJSUBDIRS))

$(OBJSUBDIRS):
	$(MKDIR) $(OBJSUBDIRS) 

clean:
	$(RM) -r "./$(OBJ)"

cleanall: clean
	$(RM) "./$(APP)"
libs:
	$(MAKE)	-C $(LIBDIR)
libs-clean:
	$(MAKE) -C $(LIBDIR) clean
libs-cleanall:
	$(MAKE) -C $(LIBDIR) cleanall


