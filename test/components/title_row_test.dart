import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifterapp/components/title_row.dart';
import 'package:lifterapp/theme.dart';

class TestScenario {
  bool isHeading;
  Color color;
  TextStyle headingStyle;

  @override
  toString() =>
      "isHeading ${isHeading}, color ${color}, headingStyle.fontSize ${headingStyle.fontSize}, headingStyle.fontWeight ${headingStyle.fontWeight}";

  TestScenario(
      {required this.isHeading,
      required this.color,
      required this.headingStyle});
}

final ValueVariant<TestScenario> variants = ValueVariant<TestScenario>({
  TestScenario(
    isHeading: true,
    color: Colors.black,
    headingStyle: GlobalTheme()
        .globalTheme
        .textTheme
        .headline1!
        .copyWith(color: Colors.black),
  ),
  TestScenario(
      isHeading: false,
      color: Colors.red,
      headingStyle: GlobalTheme()
          .globalTheme
          .textTheme
          .headline4!
          .copyWith(color: Colors.red))
});

void main() {
  testWidgets('Title row renders given text', (tester) async {
    //ASSEMBLE
    await tester.pumpWidget(const TitleRow("Otsikko"));

    //ARRANGE
    final title = find.text("Otsikko");

    //ASSERT
    expect(title, findsOneWidget);
  });

  testWidgets('Test handling of TestScenario', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: TitleRow(
          "Otsikko",
          isHeading: variants.currentValue!.isHeading,
          color: variants.currentValue!.color,
        ),
        theme: GlobalTheme().globalTheme));

    //ARRANGE
    Text title = tester.firstWidget(find.text("Otsikko"));

    //ASSERT
    expect(title.style!.color, isSameColorAs(variants.currentValue!.color));
    expect(title.style!.fontSize, variants.currentValue!.headingStyle.fontSize);
    expect(title.style!.fontWeight,
        variants.currentValue!.headingStyle.fontWeight);
  }, variant: variants);
}
