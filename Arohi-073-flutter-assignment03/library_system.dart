import 'dart:io';

/// Abstract class demonstrating Abstraction in OOP.
/// Defines the contract for any item stored in the library.
abstract class LibraryItem {
  int get id;
  String get title;
  String get author;
  int get year;

  void borrowItem();
  void returnItem();
  void displayInfo();
}

/// LoggerMixin demonstrating Interface / Mixin usage in Dart.
mixin LoggerMixin {
  void logAction(String action) {
    // Action log hook for auditing operations
  }
}

/// Concrete Book class demonstrating Encapsulation, Inheritance,
/// Method Overriding, and Polymorphism.
class Book extends LibraryItem with LoggerMixin {
  int _id;
  String _title;
  String _author;
  int _year;
  bool _isAvailable;

  Book(
    this._id,
    this._title,
    this._author,
    this._year, {
    bool isAvailable = true,
  }) : _isAvailable = isAvailable;

  @override
  int get id => _id;

  set id(int value) {
    if (value <= 0) {
      throw ArgumentError('ID must be a positive integer.');
    }
    _id = value;
  }

  @override
  String get title => _title;

  set title(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty.');
    }
    _title = value.trim();
  }

  @override
  String get author => _author;

  set author(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Author cannot be empty.');
    }
    _author = value.trim();
  }

  @override
  int get year => _year;

  set year(int value) {
    if (value <= 0 || value > DateTime.now().year) {
      throw ArgumentError('Invalid publication year.');
    }
    _year = value;
  }

  bool get isAvailable => _isAvailable;

  set isAvailable(bool value) {
    _isAvailable = value;
  }

  @override
  void borrowItem() {
    if (_isAvailable) {
      _isAvailable = false;
      print('✅ Book "$_title" (ID: $_id) borrowed successfully.');
      logAction('Borrowed book ID $_id: "$_title"');
    } else {
      print('❌ Book "$_title" (ID: $_id) is already borrowed.');
    }
  }

  @override
  void returnItem() {
    if (!_isAvailable) {
      _isAvailable = true;
      print('✅ Book "$_title" (ID: $_id) returned successfully.');
      logAction('Returned book ID $_id: "$_title"');
    } else {
      print('❌ Book "$_title" (ID: $_id) is already available in the library.');
    }
  }

  @override
  void displayInfo() {
    String status = _isAvailable ? '✅ Available' : '❌ Borrowed';
    print(
      '📚 ID: $_id | Title: $_title | Author: $_author | Year: $_year | Status: $status',
    );
  }
}

/// Library class managing the collection of books.
class Library {
  final List<Book> _books = [];

  List<Book> get books => List.unmodifiable(_books);

  bool addBook(Book book) {
    if (findBookById(book.id) != null) {
      print('❌ Error: A book with ID ${book.id} already exists.');
      return false;
    }
    _books.add(book);
    print('✅ Book "${book.title}" added successfully with ID ${book.id}.');
    return true;
  }

  void displayAllBooks() {
    if (_books.isEmpty) {
      print('ℹ️ No books available in the library.');
      return;
    }

    print('\n==================================================');
    print('📚 ALL BOOKS IN LIBRARY (${_books.length} Total)');
    print('==================================================');
    for (var book in _books) {
      book.displayInfo();
    }
  }

  void displayAvailableBooks() {
    final available = _books.where((b) => b.isAvailable).toList();
    if (available.isEmpty) {
      print('\nℹ️ No books are currently available.');
      return;
    }

    print('\n==================================================');
    print('✅ AVAILABLE BOOKS (${available.length} Total)');
    print('==================================================');
    for (var book in available) {
      book.displayInfo();
    }
  }

  void displayBorrowedBooks() {
    final borrowed = _books.where((b) => !b.isAvailable).toList();
    if (borrowed.isEmpty) {
      print('\nℹ️ No books are currently borrowed.');
      return;
    }

    print('\n==================================================');
    print('❌ BORROWED BOOKS (${borrowed.length} Total)');
    print('==================================================');
    for (var book in borrowed) {
      book.displayInfo();
    }
  }

  Book? findBookById(int id) {
    for (var book in _books) {
      if (book.id == id) {
        return book;
      }
    }
    return null;
  }

  void borrowBook(int id) {
    Book? book = findBookById(id);
    if (book == null) {
      print('❌ Error: Book with ID $id not found in the library.');
      return;
    }
    book.borrowItem();
  }

  void returnBook(int id) {
    Book? book = findBookById(id);
    if (book == null) {
      print('❌ Error: Book with ID $id not found in the library.');
      return;
    }
    book.returnItem();
  }

  void searchByTitle(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) {
      print('⚠️ Search query cannot be empty.');
      return;
    }

    final results = _books
        .where((b) => b.title.toLowerCase().contains(cleanQuery))
        .toList();

    print('\n==================================================');
    print('🔍 SEARCH RESULTS FOR "$query" (${results.length} Found)');
    print('==================================================');

    if (results.isEmpty) {
      print('❌ No books found matching title "$query".');
      return;
    }

    for (var book in results) {
      book.displayInfo();
    }
  }

  void showStatistics() {
    int total = _books.length;
    int available = _books.where((b) => b.isAvailable).length;
    int borrowed = total - available;
    double percentage = total > 0 ? (available / total) * 100 : 0.0;

    print('\n==================================================');
    print('📊 LIBRARY STATISTICS');
    print('==================================================');
    print('📖 Total Books         : $total');
    print('✅ Available Books     : $available');
    print('❌ Borrowed Books      : $borrowed');
    print('📈 Availability Rate   : ${percentage.toStringAsFixed(1)}%');
    print('==================================================');
  }
}

/// LibraryApp class managing application execution loop and menu UI.
class LibraryApp {
  final Library library;

  LibraryApp(this.library);

  void start() {
    print('\n==================================================');
    print('📚 WELCOME TO THE LIBRARY MANAGEMENT SYSTEM 📚');
    print('==================================================');

    bool running = true;

    while (running) {
      print('\n--------------------------------------------------');
      print('📋 MAIN MENU');
      print('--------------------------------------------------');
      print('1. 📚 View All Books');
      print('2. ✅ View Available Books');
      print('3. ❌ View Borrowed Books');
      print('4. ➕ Add a New Book');
      print('5. 📖 Borrow a Book');
      print('6. ↩️  Return a Book');
      print('7. 🔍 Search Books by Title');
      print('8. 📊 View Library Statistics');
      print('9. 🚪 Exit');
      print('--------------------------------------------------');
      stdout.write('Enter your choice (1-9): ');

      String? input = stdin.readLineSync();
      int? choice = int.tryParse(input?.trim() ?? '');

      if (choice == null) {
        print('⚠️ Invalid input! Please enter a valid number (1-9).');
        continue;
      }

      switch (choice) {
        case 1:
          library.displayAllBooks();
          break;
        case 2:
          library.displayAvailableBooks();
          break;
        case 3:
          library.displayBorrowedBooks();
          break;
        case 4:
          _addNewBook();
          break;
        case 5:
          _borrowBook();
          break;
        case 6:
          _returnBook();
          break;
        case 7:
          _searchBook();
          break;
        case 8:
          library.showStatistics();
          break;
        case 9:
          print('\n👋 Thank you for using the Library Management System! Goodbye.');
          running = false;
          break;
        default:
          print('⚠️ Invalid choice! Please select an option between 1 and 9.');
      }
    }
  }

  void _addNewBook() {
    print('\n==================================================');
    print('➕ ADD NEW BOOK');
    print('==================================================');

    stdout.write('Enter Book ID (Positive integer): ');
    String? idInput = stdin.readLineSync();
    int? id = int.tryParse(idInput?.trim() ?? '');

    if (id == null || id <= 0) {
      print('❌ Invalid ID! ID must be a positive integer.');
      return;
    }

    if (library.findBookById(id) != null) {
      print('❌ A book with ID $id already exists in the library.');
      return;
    }

    stdout.write('Enter Book Title: ');
    String title = (stdin.readLineSync() ?? '').trim();
    if (title.isEmpty) {
      print('❌ Book title cannot be empty.');
      return;
    }

    stdout.write('Enter Author Name: ');
    String author = (stdin.readLineSync() ?? '').trim();
    if (author.isEmpty) {
      print('❌ Author name cannot be empty.');
      return;
    }

    stdout.write('Enter Publication Year: ');
    String? yearInput = stdin.readLineSync();
    int? year = int.tryParse(yearInput?.trim() ?? '');
    int currentYear = DateTime.now().year;

    if (year == null || year <= 0 || year > currentYear) {
      print('❌ Invalid publication year! Must be between 1 and $currentYear.');
      return;
    }

    Book newBook = Book(id, title, author, year);
    library.addBook(newBook);
  }

  void _borrowBook() {
    print('\n==================================================');
    print('📖 BORROW BOOK');
    print('==================================================');

    stdout.write('Enter Book ID to borrow: ');
    String? idInput = stdin.readLineSync();
    int? id = int.tryParse(idInput?.trim() ?? '');

    if (id == null || id <= 0) {
      print('❌ Invalid ID format.');
      return;
    }

    library.borrowBook(id);
  }

  void _returnBook() {
    print('\n==================================================');
    print('↩️ RETURN BOOK');
    print('==================================================');

    stdout.write('Enter Book ID to return: ');
    String? idInput = stdin.readLineSync();
    int? id = int.tryParse(idInput?.trim() ?? '');

    if (id == null || id <= 0) {
      print('❌ Invalid ID format.');
      return;
    }

    library.returnBook(id);
  }

  void _searchBook() {
    print('\n==================================================');
    print('🔍 SEARCH BOOK BY TITLE');
    print('==================================================');

    stdout.write('Enter title or keyword to search: ');
    String query = (stdin.readLineSync() ?? '').trim();

    if (query.isEmpty) {
      print('❌ Search query cannot be empty.');
      return;
    }

    library.searchByTitle(query);
  }
}

void main() {
  Library library = Library();

  // Pre-populate with 5 sample books
  library.addBook(Book(1, 'The Alchemist', 'Paulo Coelho', 1988));
  library.addBook(Book(2, 'Atomic Habits', 'James Clear', 2018));
  library.addBook(Book(3, 'Harry Potter and the Sorcerer\'s Stone', 'J.K. Rowling', 1997));
  library.addBook(Book(4, 'Clean Code', 'Robert C. Martin', 2008));
  library.addBook(Book(5, 'Project Hail Mary', 'Andy Weir', 2021));

  LibraryApp app = LibraryApp(library);
  app.start();
}
