import 'package:flutter/material.dart';

class FancyContainer extends StatefulWidget {
  const FancyContainer({
    Key? key,
    this.height = 120.0,
    this.width,
    this.color1,
    this.color2,
    this.date,
    this.sender,
    this.statusCode,
    this.textColor,
    this.subtitle,
    this.subtitleColor,
    this.onTap,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
  }) : super(key: key);

  final double? width;
  final double height;
  final Color? color1;
  final Color? color2;
  final String? date;
  final String? sender;
  final String? statusCode;
  final Color? textColor;
  final String? subtitle;
  final Color? subtitleColor;
  final Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  @override
  _FancyContainerState createState() => _FancyContainerState();
}

class _FancyContainerState extends State<FancyContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Container(
        width: widget.width ?? MediaQuery.of(context).size.width * 0.90,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(colors: [
            widget.color1 ?? const Color(0xFFCB1841),
            widget.color2 ?? const Color(0xFF2604DE)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.date??'no date',
                    style: widget.titleStyle ??
                        TextStyle(
                          color: widget.textColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    widget.sender??'no sender',
                    style: widget.titleStyle ??
                        TextStyle(
                          color: widget.textColor,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(widget.statusCode??'no statusCode'),
                ],
              ),
            ),
            widget.subtitle != null
                ? Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                widget.subtitle ?? "",
                style: widget.subtitleStyle ??
                    TextStyle(
                      color: widget.subtitleColor,
                      fontSize: 13.0,
                    ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}