class FormInputViewModel<T> {
  final T? value;
  final void Function(T?) updateValue;

  FormInputViewModel({required this.value, required this.updateValue});
}
