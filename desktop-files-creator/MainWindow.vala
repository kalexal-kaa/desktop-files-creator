
using Gtk;

namespace Creator {

    public class MainWindow : Gtk.ApplicationWindow {
    
    
   private Entry entry_name;
   private Entry entry_exec;
   private Entry entry_icon;
   private Entry entry_categories;
   private Entry entry_comment;
   private TextView text_view;
   private CheckButton checkbutton_no_display;
   private CheckButton checkbutton_terminal;
   private string path_to_file="";
        

        public MainWindow(Gtk.Application application) {
            GLib.Object(application: application,
                         title: "Desktop Files Creator",
                         resizable: true,
                         height_request: 650,
                         width_request: 450,
                         border_width: 10);
        }        

        construct {
            var toolbar = new Toolbar ();
        toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
        var open_icon = new Gtk.Image.from_icon_name ("document-open", IconSize.SMALL_TOOLBAR);
        var save_icon = new Gtk.Image.from_icon_name ("document-save", IconSize.SMALL_TOOLBAR);
        var clear_icon = new Gtk.Image.from_icon_name ("edit-clear", IconSize.SMALL_TOOLBAR);
        var delete_icon = new Gtk.Image.from_icon_name ("edit-delete", IconSize.SMALL_TOOLBAR);
        var open_button = new Gtk.ToolButton (open_icon, "Open");
        open_button.is_important = true;
        var save_button = new Gtk.ToolButton (save_icon, "Save");
        save_button.is_important = true;
        var clear_button = new Gtk.ToolButton (clear_icon, "Clear");
        clear_button.is_important = true;
        var delete_button = new Gtk.ToolButton (delete_icon, "Delete");
        delete_button.is_important = true;
        toolbar.add (open_button);
        toolbar.add (save_button);
        toolbar.add (clear_button);
        toolbar.add (delete_button);
        open_button.clicked.connect (on_open_clicked);
        save_button.clicked.connect (on_save_clicked);
        clear_button.clicked.connect (on_clear_clicked);
        delete_button.clicked.connect (on_delete_clicked);
        entry_name = new Entry();
        var label_name = new Label.with_mnemonic ("_Name:");
        var hbox_name = new Box (Orientation.HORIZONTAL, 20);
        hbox_name.pack_start (label_name, false, true, 0);
        hbox_name.pack_start (this.entry_name, true, true, 0);
        entry_exec = new Entry();
        var label_exec = new Label.with_mnemonic ("_Exec:");
        var button_exec = new Button.with_label("OPEN");
        button_exec.clicked.connect(on_open_exec);
        var hbox_exec = new Box (Orientation.HORIZONTAL, 20);
        hbox_exec.pack_start (label_exec, false, true, 0);
        hbox_exec.pack_start (this.entry_exec, true, true, 0);
        hbox_exec.pack_start(button_exec,true,true,0);
        entry_icon = new Entry();
        var label_icon = new Label.with_mnemonic ("_Icon:");
        var button_icon = new Button.with_label("OPEN");
        button_icon.clicked.connect(on_open_icon);
        var hbox_icon = new Box (Orientation.HORIZONTAL, 20);
        hbox_icon.pack_start (label_icon, false, true, 0);
        hbox_icon.pack_start (this.entry_icon, true, true, 0);
        hbox_icon.pack_start(button_icon,true,true,0);
        entry_categories = new Entry();
        var label_categories = new Label.with_mnemonic ("_Categories:");
        var hbox_categories = new Box (Orientation.HORIZONTAL, 20);
        hbox_categories.pack_start (label_categories, false, true, 0);
        hbox_categories.pack_start (this.entry_categories, true, true, 0);
        entry_comment = new Entry();
        var label_comment = new Label.with_mnemonic ("_Comment:");
        var hbox_comment = new Box (Orientation.HORIZONTAL, 20);
        hbox_comment.pack_start (label_comment, false, true, 0);
        hbox_comment.pack_start (this.entry_comment, true, true, 0);
        checkbutton_no_display = new CheckButton();
        checkbutton_no_display.set_label("NoDisplay");
        checkbutton_terminal = new CheckButton();
        checkbutton_terminal.set_label("Terminal");
        var button_create = new Button.with_label("CREATE");
        button_create.clicked.connect(on_create_file);
        var button_show = new Button.with_label("SHOW");
        button_show.clicked.connect(on_show_file);
        text_view = new TextView ();
        text_view.editable = true;
        text_view.cursor_visible = true;
        text_view.set_wrap_mode (Gtk.WrapMode.WORD);
        var scroll = new ScrolledWindow (null, null);
        scroll.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll.add (text_view);
        var vbox = new Box(Orientation.VERTICAL,20);
        vbox.pack_start(toolbar,false,true,0);
        vbox.pack_start(scroll,true,true,0);
        vbox.pack_start(hbox_name,false,true,0);
        vbox.pack_start(hbox_exec,false,true,0);
        vbox.pack_start(hbox_icon,false,true,0);
        vbox.pack_start(hbox_categories,false,true,0);
        vbox.pack_start(hbox_comment,false,true,0);
        vbox.pack_start(checkbutton_no_display,false,true,0);
        vbox.pack_start(checkbutton_terminal,false,true,0);
        vbox.pack_start(button_create,false,true,0);
        vbox.pack_start(button_show,false,true,0);
        add(vbox);
        }            
        
        private void on_open_exec(){
        var file_chooser = new FileChooserDialog ("Open Exec", this, FileChooserAction.OPEN, "_Cancel", ResponseType.CANCEL, "_Open", ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            entry_exec.set_text(file_chooser.get_filename());
        }
        file_chooser.destroy ();
   }
   
   private void on_open_icon () {
        var file_chooser = new FileChooserDialog ("Open Icon", this, FileChooserAction.OPEN, "_Cancel", ResponseType.CANCEL, "_Open", ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            entry_icon.set_text(file_chooser.get_filename());
        }
        file_chooser.destroy ();
    }
   
   private void on_create_file (){
       if(is_empty(entry_name.get_text())){
          alert("Enter the name");
          entry_name.grab_focus();
          return;
         }
         var dialog_create_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Create file "+entry_name.get_text()+".desktop ?");
          dialog_create_file.set_title("Question");
          Gtk.ResponseType result = (ResponseType)dialog_create_file.run ();
          dialog_create_file.destroy();
          if(result==Gtk.ResponseType.OK){
              create_desktop_file();
          }
   }
   
   private void on_show_file(){
       text_view.buffer.text=desktop_file();
       path_to_file="";
   }
   
   private void on_open_clicked () {
        var file_chooser = new FileChooserDialog ("Open File", this,
                                      FileChooserAction.OPEN,
                                      "_Cancel", ResponseType.CANCEL,
                                      "_Open", ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            path_to_file = file_chooser.get_filename();
            open_file (path_to_file);
        }
        file_chooser.destroy ();
    }
     
    private void on_save_clicked () {
        if(is_empty(text_view.buffer.text)){
             alert("Nothing to save");
             return;
         }
        var file_chooser = new FileChooserDialog ("Save File", this,
                                      FileChooserAction.SAVE,
                                      "_Cancel", ResponseType.CANCEL,
                                      "_Save", ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            save_file (file_chooser.get_filename(), text_view.buffer.text);
        }
        file_chooser.destroy ();
    }
    
   private void on_clear_clicked(){
       if(is_empty(text_view.buffer.text)){
             alert("Nothing to clear");
             return;
         }
       var dialog_clear_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Clear editor?");
          dialog_clear_file.set_title("Question");
          Gtk.ResponseType result = (ResponseType)dialog_clear_file.run ();
          if(result==Gtk.ResponseType.OK){
              text_view.buffer.text="";
              path_to_file="";
          }
          dialog_clear_file.destroy();
   }
   
   private void on_delete_clicked(){
         if(path_to_file==""){
            alert("Nothing to delete");
            return;
         }
         GLib.File file = GLib.File.new_for_path(path_to_file);
         var dialog_delete_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Delete file "+file.get_basename()+" ?\nPath: "+path_to_file);
         dialog_delete_file.set_title("Question");
         Gtk.ResponseType result = (ResponseType)dialog_delete_file.run ();
         dialog_delete_file.destroy();
         if(result==Gtk.ResponseType.OK){
         FileUtils.remove (path_to_file);
         if(file.query_exists()){
            alert("Delete failed");
         }else{
             if(is_empty(text_view.buffer.text)){
                 alert("File "+file.get_basename()+" is deleted!");
             }else{
                 text_view.buffer.text="";
             }
             path_to_file="";
         }
      }
   }
   
   private string desktop_file(){
        string display;
         if(checkbutton_no_display.get_active()){
             display="true";
         }else{
             display="false";
         }
         string terminal;
         if(checkbutton_terminal.get_active()){
             terminal="true";
         }else{
             terminal="false";
         }
        string desktop_string="[Desktop Entry]
Encoding=UTF-8
Type=Application
NoDisplay="+display+"
Terminal="+terminal+"
Exec="+entry_exec.get_text().strip()+"
Icon="+entry_icon.get_text().strip()+"
Name="+entry_name.get_text().strip()+"
Comment="+entry_comment.get_text().strip()+"
Categories="+entry_categories.get_text().strip();
        return desktop_string;
   }
   
   private void create_desktop_file(){
         string directory_path = Environment.get_home_dir()+"/.local/share/applications";
         GLib.File directory = GLib.File.new_for_path(directory_path);
         if(!directory.query_exists()){
            alert("Path "+directory_path+" is not exists! Cannot create file");
            return;
         }
        string path=directory_path+"/"+entry_name.get_text()+".desktop";
        save_file(path, desktop_file());
        GLib.File file = GLib.File.new_for_path(path);
         if(file.query_exists()){
            alert("File "+file.get_basename()+" is created!\nPath: "+path);
         }else{
             alert("Error! Could not create file");
         }
   }
   
    private void open_file (string filename) {
        string text;
        try {
            FileUtils.get_contents (filename, out text);
            this.text_view.buffer.text = text;
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }
    
    private void save_file (string filename, string text) {
        try {
            FileUtils.set_contents (filename, text);
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
    }
    
   private bool is_empty(string str){
        return str.strip().length == 0;
      }
    
   private void alert (string str){
          var dialog = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str);
          dialog.set_title("Message");
          dialog.run();
          dialog.destroy();
    }
  }    
}        
        
        
