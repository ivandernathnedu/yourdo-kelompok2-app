import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yourdo/main.dart';
import 'package:yourdo/models/quest.dart';
import 'package:yourdo/models/quest_category.dart';
import 'package:yourdo/models/quest_glyph.dart';
import 'package:yourdo/theme/app_theme.dart';
import 'package:yourdo/widgets/profile_tab_bar.dart';
import 'package:yourdo/widgets/quest_group_block.dart';

void main() {
  testWidgets('Home feed shows local post images', (tester) async {
    await tester.pumpWidget(const YourDoApp(startAuthenticated: true));

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Rizky Pratama'), findsWidgets);
    expect(find.text('Naya Putri'), findsOneWidget);
    expect(find.text('Bima Kurniawan'), findsOneWidget);
    expect(find.text('Sasha Wijaya'), findsWidgets);

    final images = tester.widgetList<Image>(find.byType(Image));
    final assetPaths = images
        .map((image) => image.image)
        .whereType<AssetImage>()
        .map((image) => image.assetName)
        .toSet();

    expect(assetPaths, contains('Assets/Images/post_gym.jpg'));
    expect(assetPaths, contains('Assets/Images/post_filmmaking_1.jpg'));
    expect(assetPaths, contains('Assets/Images/post_filmmaking_2.jpg'));
    expect(assetPaths, contains('Assets/Images/post_indie_game.png'));
    expect(assetPaths, contains('Assets/Images/post_hiking.jpg'));
    expect(assetPaths, contains('Assets/Images/post_running.jpg'));
  });

  testWidgets('Tapping a Home author opens that user profile', (tester) async {
    await tester.pumpWidget(const YourDoApp(startAuthenticated: true));

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rizky Pratama').first);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Showing up, lifting heavy, and stacking small wins. See you at the next session.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Quest page shows core sections', (tester) async {
    await tester.pumpWidget(const YourDoApp(startAuthenticated: true));

    expect(find.text('Browse categories'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Quests'), findsWidgets);
  });

  testWidgets('Show more toggles to Show less and collapses again', (
    tester,
  ) async {
    const category = QuestCategory(
      id: 'test',
      name: 'Test',
      color: Color(0xFF1F5EFF),
      glyph: QuestGlyph.clapperboard,
    );
    const quests = [
      Quest(
        id: 'q1',
        title: 'Quest one',
        categoryId: 'test',
        achievementLabel: 'ONE',
        description: 'First',
        glyph: QuestGlyph.clapperboard,
      ),
      Quest(
        id: 'q2',
        title: 'Quest two',
        categoryId: 'test',
        achievementLabel: 'TWO',
        description: 'Second',
        glyph: QuestGlyph.clapperboard,
      ),
      Quest(
        id: 'q3',
        title: 'Quest three',
        categoryId: 'test',
        achievementLabel: 'THREE',
        description: 'Third',
        glyph: QuestGlyph.clapperboard,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(
          body: QuestGroupBlock(
            description: 'Test group',
            quests: quests,
            categoryOf: (_) => category,
            onQuestTap: (_) {},
            initialVisibleCount: 2,
          ),
        ),
      ),
    );

    expect(find.text('Quest one'), findsOneWidget);
    expect(find.text('Quest two'), findsOneWidget);
    expect(find.text('Quest three'), findsNothing);
    expect(find.text('Show more'), findsOneWidget);
    expect(find.text('Show less'), findsNothing);

    await tester.tap(find.text('Show more'));
    await tester.pumpAndSettle();

    expect(find.text('Quest three'), findsOneWidget);
    expect(find.text('Show less'), findsOneWidget);
    expect(find.text('Show more'), findsNothing);

    await tester.tap(find.text('Show less'));
    await tester.pumpAndSettle();

    expect(find.text('Quest three'), findsNothing);
    expect(find.text('Show more'), findsOneWidget);
    expect(find.text('Show less'), findsNothing);
  });

  testWidgets('Profile tab shows header and posts', (tester) async {
    await tester.pumpWidget(const YourDoApp(startAuthenticated: true));

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Lorem Ipsum dolor'), findsOneWidget);
    expect(find.text('Quest taken'), findsOneWidget);
    expect(find.text('September'), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Thunderbolts'), findsOneWidget);
  });

  testWidgets('Profile Quests and Journeys tabs show mock lists', (tester) async {
    await tester.pumpWidget(const YourDoApp(startAuthenticated: true));
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    final questsTab = find.descendant(
      of: find.byType(ProfileTabBar),
      matching: find.text('Quests'),
    );
    await tester.ensureVisible(questsTab);
    await tester.pumpAndSettle();
    await tester.tap(questsTab);
    await tester.pumpAndSettle();

    expect(find.text('Watch a movie'), findsOneWidget);
    expect(find.text('Hang out with a friend'), findsOneWidget);
    expect(find.text('Thunderbolts'), findsNothing);

    final journeysTab = find.descendant(
      of: find.byType(ProfileTabBar),
      matching: find.text('Journeys'),
    );
    await tester.ensureVisible(journeysTab);
    await tester.pumpAndSettle();
    await tester.tap(journeysTab);
    await tester.pumpAndSettle();

    expect(find.text('Nonton Breaking Bad'), findsOneWidget);
    expect(find.text('Yogyakarta Trip'), findsOneWidget);
    expect(find.text('Watch a movie'), findsNothing);
    expect(find.text('Lorem Ipsum dolor'), findsOneWidget);
  });

  testWidgets('Login starts empty and validates required fields', (tester) async {
    await tester.pumpWidget(const YourDoApp());

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Email/username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    expect(find.text('Username wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });

  testWidgets('Login shows error for wrong credentials', (tester) async {
    await tester.pumpWidget(const YourDoApp());

    await tester.enterText(find.widgetWithText(TextField, 'Email/username'), 'demo');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'salah');
    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    expect(find.text('Memproses login...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump();

    expect(find.text('Username atau password salah'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Login succeeds and opens the app home', (tester) async {
    await tester.pumpWidget(const YourDoApp());

    await tester.enterText(find.widgetWithText(TextField, 'Email/username'), 'demo');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'password123');
    await tester.tap(find.text('LOGIN'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1400));
    await tester.pumpAndSettle();

    expect(find.text('Browse categories'), findsOneWidget);
  });

  testWidgets('Sign up page is reachable from login', (tester) async {
    await tester.pumpWidget(const YourDoApp());

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Sign up'), findsWidgets);
    expect(find.text('SIGN UP'), findsOneWidget);
    expect(find.text('Already have an account? '), findsOneWidget);
  });
}
