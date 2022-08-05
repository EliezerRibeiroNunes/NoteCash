import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


String registriesTable = "registriesTable";
String idColumn = "idColumn";
String nameColumn ="nameColumn";
String emailColumn ="emailColumn";
String phoneColumn ="phoneColumn";
String imgColumn ="imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;

 ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db  != null){
      return _db;
    }else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "registriesnew.db");

   return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
        await db.execute(
          "CREATE TABLE $registriesTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)"
        );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
      Database dbContact = await db;
      contact.id = await dbContact.insert(registriesTable, contact.toMap());
      return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(registriesTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
    where: "$id = ?",
    whereArgs: [id]);
    if(maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    }else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(registriesTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(registriesTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $registriesTable");
    List<Contact> listContact = [];
    for (Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

 Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $registriesTable"));
 }

 Future close() async{
    Database dbContact =  await db;
    dbContact.close();
  }

}


class Contact {

  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if (id != null){
        map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
      return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
