import 'dart:math';

List<String> taskMotivations = [
  'Do Something Exciting',
  'Try Something New',
  'Drink Water',
  'Eat Vegetables!',
  'Draw Something',
  'Write a Journal Entry',
  'Smell a flower',
  'Smile 😊',
  'Help Someone Else'
];
List<String> collectionMotivations = [
  'Workouts',
  'Health',
  'Writing',
  'Weight Loss',
  'Hard Stuff',
  'Daily Tasks',
  'Gardening',
  'Practice Gratitude',
  'Become my Best Self',
];

var random = Random();

String getRandomTaskMotivation() {
  return taskMotivations[random.nextInt(taskMotivations.length)];
}

String getRandomCollectionMotivation() {
  return collectionMotivations[random.nextInt(collectionMotivations.length)];
}
