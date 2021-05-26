import 'package:bloc_sample/feature_puppy/edit/bloc/image_field_bloc_builder.dart';
import 'package:bloc_sample/feature_puppy/edit/bloc/puppy_edit_form_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/resources.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/services.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class PuppyEditForm extends StatelessWidget {
  const PuppyEditForm({
    required Puppy puppy,
    required PuppyEditFormBloc puppyEditFormBloc,
    Key? key,
  })  : _puppy = puppy,
        _formBloc = puppyEditFormBloc,
        super(key: key);

  final Puppy _puppy;

  // static Puppy? puppyPublic;
  final PuppyEditFormBloc _formBloc;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => PuppyEditFormBloc(
          repository: context.read(),
          puppy: _puppy,
        ),
        child: Builder(
          builder: (context) => SafeArea(
              key: const ValueKey('PuppyEditPage'),
              child: BlocBuilder<PuppyEditFormBloc, FormBlocState>(
                  builder: (context, state) => SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          _buildImage(_formBloc),
                          const SizedBox(height: 20),
                          PuppyEditCard(
                            label: 'Name',
                            content: _buildNameField(_formBloc),
                            icon: Icons.account_box,
                          ),
                          PuppyEditCard(
                            label: 'Breed',
                            content: _buildBreedSelection(_formBloc),
                            icon: Icons.pets,
                          ),
                          PuppyEditCard(
                            label: 'Gender',
                            content: _buildGenderSelection(_formBloc),
                            icon: Icons.wc,
                          ),
                          PuppyEditCard(
                            label: 'Characteristics',
                            content: _buildCharacteristicsField(_formBloc),
                            icon: Icons.article,
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
        ),
      );


  Widget _buildImage(PuppyEditFormBloc formBloc) => ImageFieldBlocBuilder(
       fileFieldBloc: formBloc.image,
      formBloc: _formBloc,
    puppy: _puppy,
  );

  Widget _buildNameField(PuppyEditFormBloc formBloc) =>
          TextFieldBlocBuilder(
        textFieldBloc: formBloc.name,
        cursorColor: const Color(0xff333333),
        style: TextStyles.editableTextStyle,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        maxLengthEnforced: MaxLengthEnforcement.enforced,
      );

  Widget _buildBreedSelection(PuppyEditFormBloc formBloc) =>
      DropdownFieldBlocBuilder(
        selectFieldBloc: formBloc.breed,
        itemBuilder: (context, value) => value.toString().substring(10),
      );

  Widget _buildGenderSelection(PuppyEditFormBloc formBloc) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: RadioButtonGroupFieldBlocBuilder(
                  selectFieldBloc: formBloc.gender,
                  itemBuilder: (context, value) =>
                      value.toString().substring(7),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildCharacteristicsField(PuppyEditFormBloc formBloc) =>
      TextFieldBlocBuilder(
        textFieldBloc: formBloc.characteristics,
        cursorColor: const Color(0xff333333),
        key: const ValueKey('PuppyCharacteristicsInputField'),
        style: TextStyles.editableTextStyle,
        textInputAction: TextInputAction.done,
        maxLines: 8,
        maxLengthEnforced: MaxLengthEnforcement.enforced,
      );
}
