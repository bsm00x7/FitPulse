import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Boxicons extends StatelessWidget {
  const Boxicons({super.key , required this.source});
  final String source ;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      padding: EdgeInsetsGeometry.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffF7F8F8)
      ),
      child: SvgPicture.asset(source, colorFilter: ColorFilter.mode(Color(0xff1D1617), BlendMode.srcIn),),
    );
  }
}
