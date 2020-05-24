using Gtk;

namespace Creator {

    public class MainWindow : Gtk.ApplicationWindow {
   
   private Stack stack;
   private Box vbox_create_page;
   private Box vbox_edit_page;
   private Gtk.ListStore list_store;
   private TreeView tree_view;
   private GLib.List<string> list;
   private Entry entry_name;
   private Entry entry_exec;
   private Entry entry_icon;
   private Entry entry_categories;
   private Entry entry_comment;
   private TextView text_view;
   private CheckButton checkbutton_no_display;
   private CheckButton checkbutton_terminal;
   private string directory_path;
   private string item;
        

        public MainWindow(Gtk.Application application) {
            GLib.Object(application: application,
                         title: "Desktop Files Creator",
                         window_position: WindowPosition.CENTER,
                         resizable: true,
                         height_request: 450,
                         width_request: 400,
                         border_width: 10);
        }        

      construct {
        stack = new Stack ();
        stack.set_transition_duration (600);
        stack.set_transition_type (StackTransitionType.SLIDE_LEFT_RIGHT);
        add (stack);
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
        var button_edit = new Button.with_label("EDIT >>>");
        button_edit.clicked.connect(on_edit_clicked);
        vbox_create_page = new Box(Orientation.VERTICAL,20);
        vbox_create_page.pack_start(hbox_name,false,true,0);
        vbox_create_page.pack_start(hbox_exec,false,true,0);
        vbox_create_page.pack_start(hbox_icon,false,true,0);
        vbox_create_page.pack_start(hbox_categories,false,true,0);
        vbox_create_page.pack_start(hbox_comment,false,true,0);
        vbox_create_page.pack_start(checkbutton_no_display,false,true,0);
        vbox_create_page.pack_start(checkbutton_terminal,false,true,0);
        vbox_create_page.pack_start(button_create,true,false,0);
        vbox_create_page.pack_start(button_edit,true,false,0);
        stack.add(vbox_create_page);
        var toolbar = new Toolbar ();
        toolbar.get_style_context ().add_class (STYLE_CLASS_PRIMARY_TOOLBAR);
        var save_icon = new Gtk.Image.from_icon_name ("document-save", IconSize.SMALL_TOOLBAR);
        var delete_icon = new Gtk.Image.from_icon_name ("edit-delete", IconSize.SMALL_TOOLBAR);
        var clear_icon = new Gtk.Image.from_icon_name ("edit-clear", IconSize.SMALL_TOOLBAR);
        var save_button = new Gtk.ToolButton (save_icon, "Save");
        save_button.is_important = true;
        var delete_button = new Gtk.ToolButton (delete_icon, "Delete");
        delete_button.is_important = true;
        var clear_button = new Gtk.ToolButton (clear_icon, "Clear");
        clear_button.is_important = true;
        toolbar.add(save_button);
        toolbar.add(delete_button);
        toolbar.add(clear_button);
        save_button.clicked.connect (on_save_clicked);
        delete_button.clicked.connect (on_delete_clicked);
        clear_button.clicked.connect (on_clear_clicked);
   list_store = new Gtk.ListStore(Columns.N_COLUMNS, typeof(string));
           tree_view = new TreeView.with_model(list_store);
           var text = new CellRendererText ();
           var column = new TreeViewColumn ();
           column.pack_start (text, true);
           column.add_attribute (text, "markup", Columns.TEXT);
           tree_view.append_column (column);
           tree_view.set_headers_visible (false);
           tree_view.cursor_changed.connect(on_select_item);
   var scroll_tree_view = new ScrolledWindow (null, null);
        scroll_tree_view.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll_tree_view.add (this.tree_view);
        text_view = new TextView ();
        text_view.editable = true;
        text_view.cursor_visible = true;
        text_view.set_wrap_mode (Gtk.WrapMode.WORD);
        var scroll_text_view = new ScrolledWindow (null, null);
        scroll_text_view.set_policy (PolicyType.AUTOMATIC, PolicyType.AUTOMATIC);
        scroll_text_view.add (text_view);
        var button_back = new Button.with_label("<<< BACK");
        button_back.clicked.connect(on_back_clicked);
        vbox_edit_page = new Box(Orientation.VERTICAL,20);
        vbox_edit_page.pack_start(toolbar,false,true,0);
        vbox_edit_page.pack_start(scroll_tree_view,true,true,0);
        vbox_edit_page.pack_start(scroll_text_view,true,true,0);
        vbox_edit_page.pack_start(button_back,false,true,0);
        stack.add(vbox_edit_page);
        stack.visible_child = vbox_create_page;
        directory_path = Environment.get_home_dir()+"/.local/share/applications";
        GLib.File file = GLib.File.new_for_path(directory_path);
         if(!file.query_exists()){
            alert("Error!\nPath "+directory_path+" is not exists!\nThe program will not be able to perform its functions.");
            button_create.set_sensitive(false);
            button_edit.set_sensitive(false);
           }
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
         GLib.File file = GLib.File.new_for_path(directory_path+"/"+entry_name.get_text().strip()+".desktop");
         if(file.query_exists()){
            alert("A file with the same name already exists");
            return;
         }
         var dialog_create_desktop_file = new Gtk.MessageDialog(this,Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Create file "+file.get_basename()+" ?");
          dialog_create_desktop_file.set_title("Question");
          Gtk.ResponseType result = (ResponseType)dialog_create_desktop_file.run ();
          dialog_create_desktop_file.destroy();
          if(result==Gtk.ResponseType.OK){
              create_desktop_file();
          }
   }
   
   private void on_edit_clicked(){
        stack.visible_child = vbox_edit_page;
        show_desktop_files();
   }
   
   private void on_back_clicked(){
        stack.visible_child = vbox_create_page;
   }
   
   private void on_save_clicked(){
        var selection = tree_view.get_selection();
           selection.set_mode(SelectionMode.SINGLE);
           TreeModel model;
           TreeIter iter;
           if (!selection.get_selected(out model, out iter)) {
               alert("Choose a file");
               return;
           }
           if(is_empty(text_view.buffer.text)){
             alert("Nothing to save");
             return;
         }
         GLib.File file = GLib.File.new_for_path(directory_path+"/"+item);
         var dialog_save_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Save file "+file.get_basename()+" ?");
         dialog_save_file.set_title("Question");
         Gtk.ResponseType result = (ResponseType)dialog_save_file.run ();
         if(result==Gtk.ResponseType.OK){
         try {
            FileUtils.set_contents (file.get_path(), text_view.buffer.text);
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
      }
      dialog_save_file.destroy();
   }
   
   private void on_delete_clicked(){
       var selection = tree_view.get_selection();
           selection.set_mode(SelectionMode.SINGLE);
           TreeModel model;
           TreeIter iter;
           if (!selection.get_selected(out model, out iter)) {
               alert("Choose a file");
               return;
           }
           GLib.File file = GLib.File.new_for_path(directory_path+"/"+item);
         var dialog_delete_file = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL,Gtk.MessageType.QUESTION, Gtk.ButtonsType.OK_CANCEL, "Delete file "+file.get_basename()+" ?");
         dialog_delete_file.set_title("Question");
         Gtk.ResponseType result = (ResponseType)dialog_delete_file.run ();
         dialog_delete_file.destroy();
         if(result==Gtk.ResponseType.OK){
         FileUtils.remove (directory_path+"/"+item);
         if(file.query_exists()){
            alert("Delete failed");
         }else{
             show_desktop_files();
             text_view.buffer.text="";
         }
      }
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
          }
          dialog_clear_file.destroy();
   }
   
   private void on_select_item () {
           var selection = tree_view.get_selection();
           selection.set_mode(SelectionMode.SINGLE);
           TreeModel model;
           TreeIter iter;
           if (!selection.get_selected(out model, out iter)) {
               return;
           }
           TreePath path = model.get_path(iter);
           var index = int.parse(path.to_string());
           if (index >= 0) {
               item = list.nth_data(index);
           }
        string text;
        try {
            FileUtils.get_contents (directory_path+"/"+item, out text);
            text_view.buffer.text = text;
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
       }
   
   private void create_desktop_file(){
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
         string desktop_file="[Desktop Entry]
Encoding=UTF-8
Type=Application
NoDisplay="+display+"
Terminal="+terminal+"
Exec="+entry_exec.get_text().strip()+"
Icon="+entry_icon.get_text().strip()+"
Name="+entry_name.get_text().strip()+"
Comment="+entry_comment.get_text().strip()+"
Categories="+entry_categories.get_text().strip();
        string path=directory_path+"/"+entry_name.get_text()+".desktop";
        try {
            FileUtils.set_contents (path, desktop_file);
        } catch (Error e) {
            stderr.printf ("Error: %s\n", e.message);
        }
        GLib.File file = GLib.File.new_for_path(path);
         if(file.query_exists()){
             alert("File "+file.get_basename()+" is created!\nPath: "+path);
         }else{
             alert("Error! Could not create file");
         }
       }
       
       private bool is_empty(string str){
        return str.strip().length == 0;
        }
      
       private enum Columns {
           TEXT, N_COLUMNS
       }
       
       private void show_desktop_files () {
           list_store.clear();
           list = new GLib.List<string> ();
            try {
            Dir dir = Dir.open (directory_path, 0);
            string? name = null;
            while ((name = dir.read_name ()) != null) {
                list.append(name);
            }
        } catch (FileError err) {
            stderr.printf (err.message);
        }
         TreeIter iter;
           foreach (string item in list) {
               list_store.append(out iter);
               list_store.set(iter, Columns.TEXT, item);
           }
       }
       
       private void alert (string str){
          var dialog_alert = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, str);
          dialog_alert.set_title("Message");
          dialog_alert.run();
          dialog_alert.destroy();
       }  
    }
}
    
