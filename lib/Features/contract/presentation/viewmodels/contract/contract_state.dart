import 'package:equatable/equatable.dart';
import 'package:takween/Features/contract/data/models/contract_model.dart';

abstract class ContractState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContractInitialState extends ContractState {}

class ContractLoadingState extends ContractState {}

class ContractNotGeneratedState extends ContractState {
  final bool isLandOwner;
  final bool isGenerating;

  ContractNotGeneratedState({
    required this.isLandOwner,
    this.isGenerating = false,
  });

  ContractNotGeneratedState copyWith({bool? isLandOwner, bool? isGenerating}) {
    return ContractNotGeneratedState(
      isLandOwner: isLandOwner ?? this.isLandOwner,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }

  @override
  List<Object?> get props => [isLandOwner, isGenerating];
}

class ContractLoadedState extends ContractState {
  final ContractModel contract;
  final bool isLandOwner;
  final String? currentUserId;
  final bool isSigning;

  ContractLoadedState({
    required this.contract,
    required this.isLandOwner,
    required this.currentUserId,
    this.isSigning = false,
  });

  ContractLoadedState copyWith({
    ContractModel? contract,
    bool? isLandOwner,
    String? currentUserId,
    bool? isSigning,
  }) {
    return ContractLoadedState(
      contract: contract ?? this.contract,
      isLandOwner: isLandOwner ?? this.isLandOwner,
      currentUserId: currentUserId ?? this.currentUserId,
      isSigning: isSigning ?? this.isSigning,
    );
  }

  @override
  List<Object?> get props => [contract, isLandOwner, currentUserId, isSigning];
}

class ContractFailureState extends ContractState {
  final String message;
  ContractFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class ContractTransientError extends ContractState {
  final String message;
  ContractTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class ContractSignSuccessState extends ContractState {
  // final ContractModel contract;
  ContractSignSuccessState(
    // this.contract
    );

  @override
  List<Object?> get props => [
    // contract.id, contract.signedCount
    ];
}
