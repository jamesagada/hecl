## script.hcl - this is a series of Hecl/Android examples
## demonstrating various parts of the API.

# SimpleWidgets --
#
#	This procedure is called to put some simple widgets up on the
#	screen.

proc SimpleWidgets {} {
    global context
    global procname
    set procname SimpleWidgets

    set layoutparams [linearlayoutparams -new {FILL_PARENT WRAP_CONTENT}]

    set scroll [scrollview -new $context -layoutparams $layoutparams]

    set swlayout [linearlayout -new $context -layoutparams $layoutparams]
    $swlayout setorientation VERTICAL

    $scroll addview $swlayout

    $swlayout addview [textview -new $context \
			   -text "This is a textview" \
			   -layoutparams $layoutparams]

    $swlayout addview [button -new $context -text "This is a button" \
			   -layoutparams $layoutparams]

    $swlayout addview [edittext -new $context \
			   -text "This is editable text" \
			   -layoutparams $layoutparams]

    $swlayout addview [digitalclock -new $context \
			   -layoutparams $layoutparams]

    activity setcontentview $scroll
}

# WebView --
#
#	Demonstrate the WebView widget.

proc WebView {} {
    global context
    global procname
    set procname WebView

    set layoutparams [linearlayoutparams -new {WRAP_CONTENT WRAP_CONTENT}]

    set layout [linearlayout -new $context -layoutparams $layoutparams]
    $layout setorientation VERTICAL

    set wv [webview -new $context -layoutparams $layoutparams]
    $layout addview $wv
    activity setcontentview $layout
    # Fetch the Hecl web page, which, unfortunately, isn't all that
    # beautiful ...
    $wv loadurl http://www.hecl.org
    $wv requestfocus
}

# Callback --
#
#	Generic callback proc to hand off to various widgets.

proc Callback {args} {
    set args [lrange $args 1 -1]
    alert "Callback called with arguments: $args"
}

# DatePicker --
#
#	Put a datepicker dialog up on the screen.

proc DatePicker {} {
    global context

    set callback [callback -new [list [list Callback]]]
    set dp [datedialog -new [list $context $callback [i 2007] [i 10] [i 10] [i 1]]]
    $dp show
}

# TimePicker --
#
#	Put a time picker dialog up on the screen.

proc TimePicker {} {
    global context

    set callback [callback -new [list [list Callback]]]
    set tp [timedialog -new \
		[list $context $callback \
		     "It's 5 o'clock somewhere" [i 5] [i 0] [i 1]]]
    $tp show
}

# ProgressDialog --
#
#	Create a "progress bar", and, via the updateProgress proc,
#	update it and finally dismiss it.

proc ProgressDialog {} {
    global context
    set pd [progressdialog show $context "Working..." \
		"This is a progress \"bar\"" [i 0] [i 0]]
    updateProgress $pd 0
}

# updateProgress --
#
#	This proc is called at intervals to update the progress
#	dialog, and then dismiss it when its time is up.  This is done
#	via the after command.

proc updateProgress {pd progress} {
    $pd setprogress [i $progress]
    if { < $progress 10000 } {
	after 1000 [list updateProgress $pd [+ 2000 $progress]]
    } else {
	$pd dismiss
    }
}

# RadioButtons --
#
#	Put some radio buttons up on the screen.  These don't work
#	correctly due to a bug in Android.

proc RadioButtons {} {
    global procname
    set procname RadioButtons
    global context

    set layoutparams [radiogrouplayoutparams -new {FILL_PARENT WRAP_CONTENT}]

    set layout [linearlayout -new $context]
    $layout setorientation VERTICAL

    # Since this is added to the linearlayout, it has to have
    # linearlayoutparams
    set radiogroup \
	[radiogroup -new $context \
	     -layoutparams [linearlayoutparams -new {FILL_PARENT FILL_PARENT}]]

    $radiogroup setorientation VERTICAL

    $layout addview $radiogroup

    # FIXME - broken - but it's Google's fault!
    $radiogroup addview [radiobutton -new $context \
			     -text "Android" -layoutparams $layoutparams]
    $radiogroup addview [radiobutton -new $context \
			     -text "JavaME" -layoutparams $layoutparams]
    $radiogroup addview [radiobutton -new $context \
			     -text "Flash Lite" -layoutparams $layoutparams]
    activity setcontentview $layout
}

# CheckBoxes --
#
#	Put some checkboxes up on the screen, and, through the
#	CheckBoxCallback proc, make sure that only two of the three
#	are selected.

proc CheckBoxes {} {
    global procname
    set procname CheckBoxes
    global context

    set layoutparams [linearlayoutparams -new {FILL_PARENT WRAP_CONTENT}]

    set layout [linearlayout -new $context]
    $layout setorientation VERTICAL

    $layout addview [textview -new $context -text "Pick any two:" \
			 -layoutparams $layoutparams]

    set cb1 [checkbox -new $context \
		 -text "Fast" -layoutparams $layoutparams]
    set cb2 [checkbox -new $context \
		 -text "Cheap" -layoutparams $layoutparams]
    set cb3 [checkbox -new $context \
		 -text "Good" -layoutparams $layoutparams]

    set callback [callback -new [list [list CheckBoxCallback $cb1 $cb2 $cb3]]]

    foreach cb [list $cb1 $cb2 $cb3] {
	$cb setoncheckedchangelistener $callback
	$layout addview $cb
    }

    activity setcontentview $layout
}

# CheckBoxCallback --
#
#	This is the callback for the CheckBox code.  It ensures that
#	the user can only select two out of the three options.

proc CheckBoxCallback {cb1 cb2 cb3 checkbox ischecked} {
    # Only do something if the checkbox has been checked, rather than
    # unchecked.
    if { = 1 $ischecked } {
	set total 0
	foreach cb [list $cb1 $cb2 $cb3] {
	    incr $total [$cb ischecked]
	}
	# If they've checked the third of three, uncheck it.
	if { = $total 3 } {
	    $checkbox setchecked [i 0]
	}
    }
}

# Spinner --
#
#	Displays a spinner, and links it to a textview via a callback,
#	SpinnerCallback.

proc Spinner {} {
    global procname
    set procname Spinner
    global context

    set layoutparams [linearlayoutparams -new {FILL_PARENT WRAP_CONTENT}]

    set layout [linearlayout -new $context]
    $layout setorientation VERTICAL

    # For the moment, spinners and listviews require this rather ugly
    # arrayadapter stuff.  We're working on something better.
    set lista [arrayadapter -new \
		   [list $context \
			[reslookup android.R.layout.simple_spinner_item] \
			[list "Wheel" "Of" "Fortune!"]]]

    $lista setdropdownviewresource \
	[reslookup android.R.layout.simple_spinner_dropdown_item]

    set spinner [spinner -new $context -layoutparams $layoutparams]
    $spinner setadapter $lista
    $layout addview $spinner
    # requestfocus is necessary or you won't be able to access the
    # spinner if it's redisplayed.  I think this is an Android bug.
    $spinner requestfocus

    set selected [textview -new $context -text "Currently selected: Wheel" \
		      -layoutparams $layoutparams]
    $layout addview $selected

    set callback [callback -new [list [list SpinnerCallback $selected]]]
    $spinner setonitemselectedlistener $callback

    activity setcontentview $layout
}

# SpinnerCallback --
#
#	Display the currently selected spinner item.

proc SpinnerCallback {textview parent view position id} {
    set text [$view gettext]
    $textview settext "Currently selected: $text"
}

# SelectDemo --
#
#	Select which demo to display.

proc SelectDemo {parent view position id} {
    set dest [$view gettext]
    if { eq $dest "Simple Widgets" } {
	SimpleWidgets
    } elseif {eq $dest "Web View"} {
	WebView
    } elseif {eq $dest "Date Picker"} {
	DatePicker
    } elseif {eq $dest "Progress Dialog"} {
	ProgressDialog
    } elseif {eq $dest "Radio Buttons"} {
	RadioButtons
    } elseif {eq $dest "CheckBoxes"} {
	CheckBoxes
    } elseif {eq $dest "Spinner"} {
	Spinner
    } elseif {eq $dest "Time Picker"} {
	TimePicker
    }
}

# viewCode --
#
#	View the code of the proc that is currently displayed.

proc viewCode {} {
    global procname

    set context [activity getcontext]
    set layout [linearlayout -new $context]
    $layout setorientation VERTICAL
    set layoutparams [linearlayoutparams -new {FILL_PARENT WRAP_CONTENT}]

    set text [intro proccode $procname]
    $layout addview [edittext -new $context \
			 -text [s $text] \
			 -layoutparams $layoutparams]

    set procname viewCode
    activity setcontentview $layout
}

# main --
#
#	The initial, main screen.

proc main {} {
    global context
    global procname

    set procname main
    set layout [linearlayout -new $context]
    $layout setorientation VERTICAL
    set layoutparams [linearlayoutparams -new {FILL_PARENT WRAP_CONTENT}]

    set tv [textview -new $context -text {Welcome to Hecl on Android.  This is a short tour of all the widgets that currently function.} -layoutparams $layoutparams]

    $layout addview $tv

    set lista [arrayadapter -new \
		   [list $context \
			[reslookup android.R.layout.simple_list_item_1] \
			[list "Simple Widgets" "Web View" \
			     "Date Picker" "Time Picker" \
			     "Progress Dialog" "Spinner" \
			     "Radio Buttons" "CheckBoxes"]]]

    set callback [callback -new [list [list SelectDemo]]]

    set lview [listview -new $context -layoutparams $layoutparams \
		   -onitemclicklistener $callback]

    $lview setadapter $lista
    $lview requestfocus
    $layout addview $lview

    activity setcontentview $layout

    # Used to set up a callback for when the menu is requested by the
    # user, and it's necessary to set it up.
    menusetup {m} {
	$m add [i 0] [i 0] "View Source"
	$m add [i 0] [i 1] "Main Screen"
    }

    # Sets up the actual callback code for when a menu item is
    # selected.
    menucallback {mi} {
	set id [$mi getid]
	if { = $id 1 } {
	    main
	} elseif { = $id 0 } {
	    viewCode
	}
    }
}

# This is used everywhere, so making it a global is no big deal.
set context [activity getcontext]

# Start things running.
main
