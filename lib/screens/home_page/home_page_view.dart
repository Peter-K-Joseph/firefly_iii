import 'package:firefly_iii/screens/home_page/home_page_controller.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  final HomePageController _controller = HomePageController();
  late final Function toggleDrawer;

  HomePageView({super.key, required this.toggleDrawer});

  Widget _createNumPadIconButton(
    IconData icon,
    GestureTapCallback onTap, {
    Color backgroundColor = const Color(0xffFAFAFF),
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: InkWell(
          onLongPress: () => _controller.clearAll(),
          child: IconButton(
            onPressed: onTap,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
            ),
            enableFeedback: true,
            icon: Container(
              padding: const EdgeInsets.all(5),
              child: Icon(
                icon,
                color: Color(0xff30343F),
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createNumPad(
    String butonText,
    GestureTapCallback onTap, {
    Color backgroundColor = const Color(0xffFAFAFF),
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Text(
              butonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff30343F),
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List> _getVendorsList() {
    return FutureBuilder(
      future: _controller.getVendors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final List<String> vendors = snapshot.data as List<String>;
        vendors.sort();
        vendors.insert(0, 'search');
        return Row(
          children: vendors
              .map(
                (vendor) => Padding(
                  padding: EdgeInsets.only(
                    right: vendors.indexOf(vendor) == (vendors.length - 1)
                        ? 20
                        : 5,
                    left: vendors.indexOf(vendor) == 0 ? 20 : 0,
                  ),
                  child: (vendors.indexOf(vendor) == 0)
                      ? Chip(
                          label: Text('Search'),
                        )
                      : Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.grey.shade800,
                            child: Text(
                              vendor.substring(0, 1),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          label: Text(vendor),
                        ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: _controller.instanceNameNotifier,
          builder: (context, value, child) {
            return Text(
              value,
              style: TextStyle(
                color: Colors.white,
              ),
            );
          },
        ),
        actions: [
          InkWell(
            child: ValueListenableBuilder(
              valueListenable: _controller.priceNotifier,
              builder: (context, input, child) {
                return ValueListenableBuilder(
                  valueListenable: _controller.totalAssetValueNotifier,
                  builder: (context, value, child) {
                    final double finalValue = (value ?? 0) - input.value;
                    final String valueInString =
                        finalValue.toString().replaceAll('-', '');
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                      child: (value != null)
                          ? FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${_controller.currency}${valueInString.split('.')[0]}.${valueInString.split('.')[1].substring(0, 2)}',
                                style: TextStyle(
                                  color: finalValue < 0
                                      ? Color(0xffFF6B6B)
                                      : Color(0xff21FA90),
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () => toggleDrawer(),
        ),
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
      ),
      backgroundColor: Color(0xff30343F),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight,
                  maxWidth: constraints.maxWidth,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _getVendorsList(),
                      ),
                    ),
                    Expanded(
                      child: const SizedBox(),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _controller.priceNotifier,
                      builder: (context, value, child) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: PriceDisplayWidget(
                                  integer: value.integer,
                                  decimal: value.decimal,
                                  currency: value.currency,
                                  isDecimal: value.isPostDecimalPoint,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _createNumPad(
                                  7.toString(), () => _controller.addDigit(7)),
                              _createNumPad(
                                  8.toString(), () => _controller.addDigit(8)),
                              _createNumPad(
                                  9.toString(), () => _controller.addDigit(9)),
                            ],
                          ),
                          Row(
                            children: [
                              _createNumPad(
                                  4.toString(), () => _controller.addDigit(4)),
                              _createNumPad(
                                  5.toString(), () => _controller.addDigit(5)),
                              _createNumPad(
                                  6.toString(), () => _controller.addDigit(6)),
                            ],
                          ),
                          Row(
                            children: [
                              _createNumPad(
                                  1.toString(), () => _controller.addDigit(1)),
                              _createNumPad(
                                  2.toString(), () => _controller.addDigit(2)),
                              _createNumPad(
                                  3.toString(), () => _controller.addDigit(3)),
                            ],
                          ),
                          Row(
                            children: [
                              _createNumPad(
                                '.',
                                _controller.addDecimalPoint,
                                backgroundColor: Color(0xffFFBF46),
                              ),
                              _createNumPad(
                                0.toString(),
                                () => _controller.addDigit(0),
                              ),
                              _createNumPadIconButton(
                                Icons.backspace_outlined,
                                _controller.clearLastPosition,
                                backgroundColor: Color(0xff8ACB88),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PriceDisplayWidget extends StatelessWidget {
  final int integer;
  final String? decimal;
  final String currency;
  final bool isDecimal;

  const PriceDisplayWidget({
    super.key,
    required this.integer,
    required this.decimal,
    this.currency = '-/-',
    this.isDecimal = false,
  });

  List<Widget> decimalGenerator() {
    List<Widget> decimalList = [];
    if (decimal == null || decimal!.isEmpty) {
      decimalList.add(Text(
        '00',
        style: TextStyle(
          color: Color(0xff6B818C),
          fontSize: 50,
        ),
      ));
      return decimalList;
    } else {
      for (int i = 0; i < decimal.toString().length; i++) {
        decimalList.add(Text(
          decimal.toString()[i],
          style: TextStyle(
            color: Color(0xffFAFAFF),
            fontSize: 50,
          ),
        ));
      }
      if (decimal.toString().length < 2) {
        decimalList.add(Text(
          '0',
          style: TextStyle(
            color: Color(0xff6B818C),
            fontSize: 50,
          ),
        ));
      }
    }
    return decimalList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          currency,
          style: TextStyle(
            color: Color(0xff6B818C),
            fontSize: 30,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          integer.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              ),
          style: TextStyle(
            color: Color(0xffFAFAFF),
            fontSize: 70,
          ),
        ),
        Text(
          '.',
          style: TextStyle(
            color: (isDecimal) ? Color(0xffFAFAFF) : Color(0xff6B818C),
            fontSize: 50,
          ),
        ),
        ...decimalGenerator(),
      ],
    );
  }
}
