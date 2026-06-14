#!/usr/bin/env sqgi

local GLib = import("GLib")
local Gio = import("Gio")
local Gdk = import("Gdk", "4.0")
local Gtk = import("Gtk", "4.0")

const APP_ID = "dev.sam.sqgitemplate"

class SqgiTemplateApp {
    application = null
    window = null

    constructor() {
        local owner = this

        local GtkApplicationSubclass = sqgi.register_class({
            name = "SqgiTemplateApplication",
            parent = Gtk.Application,
            overrides = {
                startup = function(self) {
                    sqgi.chain_up()
                    owner.startup(self)
                },

                activate = function(self) {
                    owner.activate(self)
                },
            },
        })

        this.application = sqgi.new_object(GtkApplicationSubclass, {
            ["application-id"] = APP_ID,
            ["flags"] = Gio.ApplicationFlags.flags_none,
        })
    }

    function run(argc, argv) {
        return this.application.run(argc, argv)
    }

    function startup(_gtk_app) {
        local display = Gdk.Display.get_default()
        if (display == null) return

        local theme = Gtk.IconTheme.get_for_display(display)
        local resources = GLib.getenv("SQGI_APP_RESOURCES")
        if (resources != null && resources.len() > 0) {
            theme.add_search_path(GLib.build_filenamev([resources, "assets"]))
        }

        theme.add_search_path(GLib.build_filenamev([GLib.get_current_dir(), "assets"]))
        Gtk.Window.set_default_icon_name(APP_ID)
    }

    function activate(gtk_app) {
        if (this.window == null) {
            this.window = Gtk.ApplicationWindow.new(gtk_app)
            this.window.set_title("SQGI Template")
            this.window.set_default_size(420, 240)
            this.window.set_icon_name(APP_ID)
            this.window.set_child(this.build_content())
            this.window.connect("close-request", function() {
                this.window = null
                return false
            }.bindenv(this))
        }

        this.window.present()
    }

    function build_content() {
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

        return box
    }
}

local app = SqgiTemplateApp()
return app.run(0, null)
