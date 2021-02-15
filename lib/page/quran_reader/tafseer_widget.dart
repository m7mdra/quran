import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/tafseer/tafseer_bloc.dart';
import 'bloc/tafseer/tafseer_state.dart';

class TafseerWidget extends StatelessWidget {
  const TafseerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        child: BlocBuilder(
          cubit: context.bloc<TafseerBloc>(),
          builder: (context, state) {
            if (state is TafseerLoadedState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(AppLocalizations.of(context).interpretation,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal)),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var tafseer = state.list[index];
                        return ListTile(
                          dense: true,
                          title: Text(tafseer.text,
                              style: TextStyle(
                                fontFamily: 'trado',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        MaterialLocalizations.of(context).closeButtonLabel),
                  )
                ],
              );
            }
            if (state is TafseerErrorState) {
              return Padding(
                padding: const EdgeInsets.all(48.0),
                child: Text(
                  'فشل ايجاد تفسير للاية',
                  style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
