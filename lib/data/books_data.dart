import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/shelf_model.dart';

class BooksData {
  static final List<Shelf> shelves = [
    Shelf(
      id: 'fiction',
      name: 'Fiction',
      icon: Icons.auto_stories,
      books: [
        Book(
          id: 'fic_1',
          title: 'The Silent River',
          author: 'Aamir Khan',
          coverImage: 'assets/books/silent_river.jpg',
          description:
              'A quiet tale of a village living beside a river that holds many secrets.',
          shelfId: 'fiction',
          chapters: const [
            Chapter(
              title: 'Chapter 1 — Morning Mist',
              englishText:
                  'The mist rose softly over the river at dawn. Birds called from the willows, and the village began to wake. Old Imran walked the bank, his boots soft on the wet sand, listening for the first ripple of the day.\n\nNothing in the river had ever harmed him, yet he watched it with the wary respect a man gives a sleeping lion.',
              urduText:
                  'صبح کے وقت دریا پر دھیمی دھیمی دھند چھائی ہوئی تھی۔ بید کے درختوں سے پرندوں کی آوازیں آ رہی تھیں اور گاؤں بیدار ہونے لگا تھا۔ بوڑھا عمران دریا کے کنارے چل رہا تھا، اس کے بوٹ گیلی ریت پر آہستہ پڑ رہے تھے۔\n\nدریا نے اسے کبھی نقصان نہیں پہنچایا تھا، پھر بھی وہ اسے سوئے ہوئے شیر کی طرح احترام سے دیکھتا تھا۔',
            ),
            Chapter(
              title: 'Chapter 2 — The Stranger',
              englishText:
                  'A stranger came at noon, carrying a bag of fish and a story no one believed. He sat by the well and spoke of distant cities, of trains that never stopped, and of a song he could not forget.',
              urduText:
                  'دوپہر کے وقت ایک اجنبی آیا، اس کے ہاتھ میں مچھلیوں کا تھیلا تھا اور ایک ایسی کہانی جسے کوئی نہیں مانتا تھا۔ وہ کنویں کے پاس بیٹھا اور دور کے شہروں کی، نہ رکنے والی ریل گاڑیوں کی، اور ایک ایسے گیت کی بات کرنے لگا جسے وہ بھول نہیں سکتا تھا۔',
            ),
          ],
        ),
        Book(
          id: 'fic_2',
          title: 'Letters from Lahore',
          author: 'Sara Ahmed',
          coverImage: 'assets/books/letters_lahore.jpg',
          description:
              'A young woman writes home from a city she barely understands.',
          shelfId: 'fiction',
          chapters: const [
            Chapter(
              title: 'Letter One',
              englishText:
                  'Dear Ammi,\n\nThe city is louder than I imagined and softer too. The walls of the old town remember more than I can ever learn in a lifetime.',
              urduText:
                  'پیاری امی،\n\nشہر اس سے کہیں زیادہ شور والا ہے جتنا میں نے سوچا تھا، اور کہیں زیادہ نرم بھی۔ پرانے شہر کی دیواریں اس سے کہیں زیادہ یاد رکھتی ہیں جتنا میں زندگی بھر میں سیکھ سکتی ہوں۔',
            ),
          ],
        ),
      ],
    ),
    Shelf(
      id: 'islamic',
      name: 'Islamic',
      icon: Icons.mosque,
      books: [
        Book(
          id: 'isl_1',
          title: 'The Beautiful Names',
          author: 'Imam Yusuf',
          coverImage: 'assets/books/beautiful_names.jpg',
          description:
              'A reflection on the 99 names of Allah and their meanings in daily life.',
          shelfId: 'islamic',
          chapters: const [
            Chapter(
              title: 'Ar-Rahman — The Most Merciful',
              englishText:
                  'Mercy is not weakness; it is the strength to forgive when one could punish, and to give when one could withhold. Ar-Rahman is the One whose mercy reaches every breath of every creature.',
              urduText:
                  'رحم کمزوری نہیں ہے؛ یہ وہ طاقت ہے جو سزا دینے کی قدرت کے باوجود معاف کر دے، اور روک لینے کی قدرت کے باوجود عطا کر دے۔ الرحمٰن وہ ذات ہے جس کی رحمت ہر مخلوق کی ہر سانس تک پہنچتی ہے۔',
            ),
          ],
        ),
      ],
    ),
    Shelf(
      id: 'children',
      name: "Children's",
      icon: Icons.child_friendly,
      books: [
        Book(
          id: 'ch_1',
          title: 'The Brave Little Sparrow',
          author: 'Mehwish Iqbal',
          coverImage: 'assets/books/brave_sparrow.jpg',
          description:
              'A small bird with a big heart sets out on a journey across the garden.',
          shelfId: 'children',
          chapters: const [
            Chapter(
              title: 'A New Friend',
              englishText:
                  'The little sparrow hopped from branch to branch. "I will see the whole garden today!" she said. A frog blinked at her from the pond. "Will you take me with you?" he asked.',
              urduText:
                  'ننھی چڑیا ایک شاخ سے دوسری شاخ پر پھدکنے لگی۔ "میں آج پورا باغ دیکھوں گی!" اس نے کہا۔ تالاب سے ایک مینڈک نے آنکھیں جھپکائیں۔ "کیا تم مجھے بھی ساتھ لے جاؤ گی؟" اس نے پوچھا۔',
            ),
          ],
        ),
      ],
    ),
    Shelf(
      id: 'poetry',
      name: 'Poetry',
      icon: Icons.format_quote,
      books: [
        Book(
          id: 'po_1',
          title: 'Whispers of the Garden',
          author: 'Faiz Mehmood',
          coverImage: 'assets/books/whispers_garden.jpg',
          description: 'A collection of short verses inspired by gardens and seasons.',
          shelfId: 'poetry',
          chapters: const [
            Chapter(
              title: 'Spring',
              englishText:
                  'A petal falls — the wind has turned a page in the long book of the year.',
              urduText:
                  'ایک پتی گری — ہوا نے سال کی طویل کتاب کا ایک ورق پلٹ دیا۔',
            ),
            Chapter(
              title: 'Evening',
              englishText:
                  'The lamps come on one by one, like quiet promises spoken at dusk.',
              urduText:
                  'چراغ ایک ایک کر کے روشن ہوتے ہیں، جیسے شام کے وقت دھیمے سے کیے گئے وعدے۔',
            ),
          ],
        ),
      ],
    ),
  ];

  static Shelf? shelfById(String id) {
    for (final s in shelves) {
      if (s.id == id) return s;
    }
    return null;
  }

  static Book? bookById(String id) {
    for (final s in shelves) {
      for (final b in s.books) {
        if (b.id == id) return b;
      }
    }
    return null;
  }

  static List<Book> get allBooks =>
      shelves.expand((s) => s.books).toList(growable: false);
}
