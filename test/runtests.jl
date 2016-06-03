using GtkInteract
using Base.Test

## test manipulate
@manipulate for n=1:10
    n
end



## tests widgets
opts = ["one", "two", "three"]
# write your own tests here
sl = slider(1:10)         # one from range
cb = checkbox(true, label="check")      # bool
tb = togglebutton(true, label="toggle") # bool
dd = dropdown(opts)       # 1 of n
rbs = radiobuttons(opts)  # 1 of n
sel = selectlist(opts, label="select")        # 1 of n
tbs = togglebuttons(opts) # 1 of n
bg = buttongroup(opts)    # 0,1,...,n of n
txtb = textbox("text goes here", label="textbox")

btn = button("button")
out = label()

controls = [sl, cb, tb, dd, rbs,  tbs, bg, sel, txtb]

w = window(vbox(controls...),
           hbox(halign(:end,padding(10, btn))),
           out)


## using Reactive
Reactive.foreach([x.signal for x in controls]...) do sl, cb, tb, dd, rbs, tbs, bg, sel, txtb
    push!(out, """
          $(string(sl))
          $(string(cb))
          $(string(tb))
          $(string(dd))
          $(string(rbs))
          $(string(tbs))
          $(string(bg))
          $(string(sel))
          $(string(txtb))
         
          """)  
end

# test numeric-valued textboxes
using Gtk, Interact
w = mainwindow()
b = textbox(1)
push!(w, b)
display(w)
g = first(w.window)
widget = first(g)
setproperty!(widget, :text, "2")
@test value(signal(b)) == 1
signal_emit(widget, :activate, Void)
sleep(0.1)
@test value(signal(b)) == 2
