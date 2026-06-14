#!/usr/bin/env sqgi

local GLib = import("GLib")
local Gio = import("Gio")
local Gtk = import("Gtk", "4.0")

const APP_ID = "dev.sam.sqgitemplate"

function has_arg(name) {
    foreach (arg in vargv) {
        if (arg == name) return true
    }
    return false
}

local smoke = has_arg("--smoke")
local app = Gtk.Application.new(APP_ID, Gio.ApplicationFlags.flags_none)

app.connect("activate", function() {
    local window = Gtk.ApplicationWindow.new(app)
    window.set_title("SQGI Template")
    window.set_default_size(420, 240)

    local box = Gtk.Box.new(Gtk.Orientation.vertical, 12)
    box.set_margin_top(24)
    box.set_margin_bottom(24)
    box.set_margin_start(24)
    box.set_margin_end(24)

    local title = Gtk.Label.new("Hello from SQGI")
    title.add_css_class("title-1")
    title.set_wrap(true)
    box.append(title)

    local message = Gtk.Label.new("This is a basic GTK4 application running on SQGI.")
    message.add_css_class("dim-label")
    message.set_wrap(true)
    box.append(message)

    local button = Gtk.Button.new_with_label("Click me")
    button.connect("clicked", function() {
        message.set_text("GTK4 is wired up and responding.")
        print("Button clicked\n")
    })
    box.append(button)

    window.set_child(box)
    window.present()

    if (smoke) {
        GLib.timeout_add(GLib.PRIORITY_DEFAULT, 250, function() {
            window.close()
            app.quit()
            return GLib.SOURCE_REMOVE
        })
    }
})

return app.run(0, null)
