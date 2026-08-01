import 'add_on.dart';

/// An add-on the guest has chosen, together with the quantity they picked.
/// A quantity of zero is never stored — the add-on is dropped from the draft
/// instead (see [ReservationWizardController.decrementAddOn]).
class SelectedAddOn {
  const SelectedAddOn({required this.addOn, required this.quantity});

  final AddOn addOn;
  final int quantity;

  SelectedAddOn copyWith({int? quantity}) =>
      SelectedAddOn(addOn: addOn, quantity: quantity ?? this.quantity);

  /// The booking-payload shape expected by the backend: just the add-on's id
  /// and the chosen quantity, not the whole add-on object.
  Map<String, dynamic> toJson() => {
        'addOnId': addOn.id,
        'quantity': quantity,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedAddOn &&
          addOn == other.addOn &&
          quantity == other.quantity;

  @override
  int get hashCode => Object.hash(addOn, quantity);
}
