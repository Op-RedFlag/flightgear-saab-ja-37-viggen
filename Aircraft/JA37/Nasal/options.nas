var optionDLG_RUNNING = 0;
var DIALOG_WIDTH = 580;
var DIALOG_HEIGHT = 250;
var TOPLOGO_HEIGHT = 80;
var SIDELOGO_WIDTH = 100;

var Dialog = {
    init: func(x = nil, y = nil) {
        me.x = x;
        me.y = y;
        me.bg = [0.3, 0.3, 0.3, 1];    # background color
        me.fg = [[0.9, 0.9, 0.2, 1], [1, 1, 1, 1], [1, 0.5, 0, 1]]; # alternative active & disabled color
        var font = { name: "FIXED_8x13" };

        me.dialog = nil;
        me.name = "JA-37 Options";

#        me.listeners=[];
#        append(me.listeners, setlistener("/sim/signals/reinit-gui", func me._redraw_()));
#        append(me.listeners, setlistener("/sim/signals/aircraft_design-updated", func me._redraw_()));
    },
    create: func {
        if (me.dialog != nil)
            me.close();

        me.dialog = gui.dialog[me.name] = gui.Widget.new();
        me.dialog.set("name", me.name);
        me.dialog.set("dialog-name", me.name);
        if (me.x != nil)
            me.dialog.set("x", me.x);
        if (me.y != nil)
            me.dialog.set("y", me.y);

        me.dialog.set("layout", "vbox");
        me.dialog.set("default-padding", 0);
        me.dialog.set("pref-width", DIALOG_WIDTH);
        me.dialog.set("pref-height", DIALOG_HEIGHT);

        me.dialog.setColor(me.bg[0], me.bg[1], me.bg[2], me.bg[3]);

        ######   Title Bar   #####
        var titlebar = me.dialog.addChild("group");
          titlebar.set("layout", "hbox");
          titlebar.set("pref-height", 32);
          titlebar.set("valign", "top");
          titlebar.set("pref-width", DIALOG_WIDTH);
          titlebar.addChild("empty").set("stretch", 1);
          titlebar.addChild("text").set("label", "Saab JA-37 Viggen Options");
          titlebar.addChild("empty").set("stretch", 1);
          var w = titlebar.addChild("button");
            w.node.setValues({ "pref-width": 16, "pref-height": 16, legend: "", default: 0 });
            # "Esc" causes dialog-close
            w.set("key", "Esc");
            w.setBinding("nasal", "ja37.Dialog.del()");

        me.dialog.addChild("hrule");

        #####   Top logo   #####
        #var topLogo = me.dialog.addChild("group");
        #topLogo.set("layout", "hbox");
        #topLogo.set("halign", "fill");
        #topLogo.set("valign", "top");
        #topLogo.set("pref-height", TOPLOGO_HEIGHT);
        #topLogo.set("row", 0);
        #topLogo.set("col", 0);

        #var canvas_settings = {
        #  "name": "LogoNasal",
        #  "size": [256, 64],# width of texture to be replaced
        #  "view": [512, 128],# width of canvas
        #  "mipmapping": 0
        #};
        
        #var canvasLogo = canvas.new(canvas_settings);
        #canvasLogo.addPlacement({"parent": canvasWidget.prop()});
        #canvasLogo.setSize(512, 128);
        #var root = canvasLogo.createGroup();
        #var splash = root.createChild("image");
        #splash.setFile("Aircraft/JA37/viggen-logo.png");
        #splash.setSize(512, 128);
        #splash.setTranslation(0,0);
        #splash.setSourceRect(0, 0, 1, 1, 1);
        
        #canvasLogo._node.addChild("pref-width").setValue(100);
        #canvasLogo._node.addChild("pref-height").setValue(100);
        #var canvasWidget = me.dialog.addChild("canvas");
        #canvasWidget.prop().addChild(canvasLogo._node);

        me.dialog.addChild("hrule");

        #####   Main Area   #####
        var mainArea = me.dialog.addChild("group");
          mainArea.set("layout", "hbox");
          mainArea.set("valign", "fill");
          mainArea.set("halign", "fill");
          mainArea.set("pref-height", DIALOG_HEIGHT - 72 - TOPLOGO_HEIGHT);

          #####   Side logo   #####
          var sideLogo = mainArea.addChild("group");
            sideLogo.set("layout", "vbox");
            sideLogo.set("pref-width", SIDELOGO_WIDTH);
            sideLogo.set("valign", "fill");
            mainArea.addChild("vrule");

          #####   Work Area   #####
          var workArea = mainArea.addChild("group");
            workArea.set("layout", "vbox");
            workArea.set("pref-width", DIALOG_WIDTH - SIDELOGO_WIDTH - 12);
            workArea.set("valign", "fill");
            workAreaNode = workArea.node;

            #######################
            #####   Content   #####
            #######################

          ######   Top Row break button   #####
          me.dialog.addChild("hrule");
          var topRow = workArea.addChild("group");
          topRow.set("layout", "vbox");
          topRow.set("pref-height", 40);
          topRow.set("pref-width", DIALOG_WIDTH - SIDELOGO_WIDTH - 12);
          topRow.set("valign", "center");
          topRow.addChild("empty").set("stretch", 1);
          
          me.dialog.breakButton = topRow.addChild("button");
          me.dialog.breakButton.node.setValues({ "pref-width": 300, "pref-height": 25, legend: "Aircraft structural break due to G-forces is ", default: 0 });
          topRow.addChild("empty").set("stretch", 1);
          me.dialog.breakButton.setBinding("nasal", "ja37.Dialog.breakToggle()");

          ######   Top Row reverse button   #####
          
          me.dialog.reverseButton = topRow.addChild("button");
          me.dialog.reverseButton.node.setValues({ "pref-width": 300, "pref-height": 25, legend: "Automatic reverse thrust enabler at touchdown: OFF", default: 0 });
          topRow.addChild("empty").set("stretch", 1);
          me.dialog.reverseButton.setBinding("nasal", "ja37.Dialog.reverseToggle()");

          #var me.dialog.crashButton = topRow.addChild("button");
          #me.dialog.crashButton.node.setValues({ "pref-width": 80, "pref-height": 25, legend: "Crash", default: 0 });
          #topRow.addChild("empty").set("stretch", 1);
          #crashButton.setBinding("nasal", "ja37.dialog.crash()");

####  The table will be filled from the current page after doing some sort
####  of combination of wizard.pui and the nasal code in wizard.xml

        ######   Bottom Row Buttons   #####
        #me.dialog.addChild("hrule");
        #var bottomRow = me.dialog.addChild("group");
        #  bottomRow.set("layout", "hbox");
        #  bottomRow.set("pref-height", 40);
        #  bottomRow.set("pref-width", DIALOG_WIDTH);
        #  bottomRow.set("valign", "bottom");
        #  bottomRow.addChild("empty").set("stretch", 1);
        #  var testButton = bottomRow.addChild("button");
        #     testButton.node.setValues({ "pref-width": 80, "pref-height": 25, legend: "Prev", default: 0 });
        #  bottomRow.addChild("empty").set("stretch", 1);
        #  var secondButton = bottomRow.addChild("button");
        #     secondButton.node.setValues({ "pref-width": 80, "pref-height": 25, legend: "Next", default: 0 });
        #  bottomRow.addChild("empty").set("stretch", 1);

        me.refreshButtons();
        fgcommand("dialog-new", me.dialog.prop());
        fgcommand("dialog-show", me.dialog.prop());
    },

    close: func {
        fgcommand("dialog-close", me.dialog.prop());
    },

    breakToggle: func {
      var enabled = getprop("processes/aircraft-break/enabled");
      setprop("processes/aircraft-break/enabled", !enabled);
      me.refreshButtons();
    },

    reverseToggle: func {
      var enabled = getprop("processes/aircraft-break/autoReverseThrust");
      setprop("processes/aircraft-break/autoReverseThrust", !enabled);
      me.refreshButtons();
    },

    refreshButtons: func {
      # update break button
      var enabled = getprop("processes/aircraft-break/enabled");
      var legend = "Aircraft structural break due to G-forces is ";
      if(enabled == 1) {
        legend = legend~"ON";
      } else {
        legend = legend~"OFF";
      }
      me.dialog.breakButton.node.setValues({"legend": legend});

      enabled = getprop("processes/aircraft-break/autoReverseThrust");
      legend = "Automatic reverse thrust enabler at touchdown: ";
      if(enabled == 1) {
        legend = legend~"ON";
      } else {
        legend = legend~"OFF";
      }
      me.dialog.reverseButton.node.setValues({"legend": legend});

      #props.dump(me.dialog.prop()); # handy command, don't forget it.

      # this is commented out cause it needs a trigger (e.g. button to activate):
      # me.dialog.setBinding("dialog-close", props.Node.new({"dialog-name": "JA-37 Options"}));
      # me.dialog.setBinding("dialog-show",  props.Node.new({"dialog-name": "JA-37 Options"}));
      # this does the same, refresh the dialog:
      fgcommand("dialog-close", props.Node.new({"dialog-name": "JA-37 Options"}));
      fgcommand("dialog-show", props.Node.new({"dialog-name": "JA-37 Options"}));
    },

    del: func {
        optionDLG_RUNNING = 0;
        me.close();
#        foreach (var l; me.listeners)
#            removelistener(l);
        delete(gui.dialog, me.name);
    },

    show: func {
      var versionString = getprop("sim/version/flightgear");
      var version = split(".", versionString);
      if (version[0] == "0" or version[0] == "1" or version[0] == "2") {
        gui.popupTip("Options is only supported in Flightgear version 3.0 and upwards.");
      } elsif (!optionDLG_RUNNING) {
        optionDLG_RUNNING = 1;
        me.init();
        me.create();
      }
    },
};