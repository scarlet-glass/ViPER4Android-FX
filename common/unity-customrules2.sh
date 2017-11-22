TIMEOFEXEC=1

# GET OLD/NEW FROM ZIP NAME
case $(basename $ZIP) in
  *old*|*Old*|*OLD*) UI=21; MAT=false;;
  *orig*|*Orig*|*ORIG*) UI=42; MAT=false;;
  *mat*|*Mat*|*MAT*) MAT=true;;
esac

# Keycheck binary by someone755 @Github, idea for code below by Zappo @xda-developers
KEYCHECK=$INSTALLER/common/keycheck
chmod 755 $KEYCHECK

chooseport() {
  $KEYCHECK
  INPUT=$?
  if [[ $INPUT -eq 42 ]] || [[ $INPUT -eq 21 ]]; then
    UI=$INPUT
  else
    ui_print "   ! Unrecognized key!"
    UI=42
  fi
  shift
}

ui_print " "
ui_print "- Select Version -"
if [ -z $MAT ]; then
  ui_print "   Choose which V4A you want installed:"
  ui_print "   Vol+ = new (2.5.0.5), Vol- = old (2.3.4.0)"
  ui_print "   Old V4A will install super quality driver"
  chooseport
else
  ui_print "   V4A version specified in zipname!"
fi
if [[ $UI -eq 21 ]]; then
  ui_print "   Old V4A will be installed"
  cp -f $INSTALLER/custom/Old/ViPER4AndroidFX.apk $INSTALLER/system/app/ViPER4AndroidFX/ViPER4AndroidFX.apk
  cp -f $INSTALLER/custom/Old/libv4a_fx_jb_NEON.so $INSTALLER/custom/libv4a_fx_jb_NEON.so
  cp -f $INSTALLER/custom/Old/libv4a_fx_jb_X86.so $INSTALLER/custom/libv4a_fx_jb_X86.so
  sed -ri "s/version=(.*)/version=\1 (2.3.4.0)/" $INSTALLER/module.prop
else
  UI=""
  if [ -z $MAT ]; then
    ui_print "   New V4A will be installed"
    ui_print "   Choose which V4A you want installed:"
    ui_print "   Vol+ = original, Vol- = materialized"
    sleep 1
    chooseport
  elif [ "$MAT" == true ]; then
	UI=21
  else
    UI=42
  fi
  if [[ $UI -eq 21 ]]; then
    ui_print "   Materialized V4A by pittvandewit will be installed"
    sed -ri "s/version=(.*)/version=\1 (2.5.0.5 Materialized)/" $INSTALLER/module.prop
    sed -ri "s/author=(.*)/version=\1,pittvandewit/" $INSTALLER/module.prop
    cp -f $INSTALLER/custom/Materialized/ViPER4AndroidFX.apk $INSTALLER/system/app/ViPER4AndroidFX/ViPER4AndroidFX.apk
  else
    ui_print "   Original V4A will be installed"
    sed -ri "s/version=(.*)/version=\1 (2.5.0.5)/" $INSTALLER/module.prop
  fi
fi
