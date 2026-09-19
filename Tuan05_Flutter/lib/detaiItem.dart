import 'package:flutter/material.dart';
import 'detai.dart';

class DeTaiItem extends StatelessWidget {
  final DeTai deTai;

  const DeTaiItem({super.key, required this.deTai});

  static const TextStyle _textStyle = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 230,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: const Color.fromARGB(255, 200, 197, 177),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              deTai.getMaDeTai,
              style: _textStyle,
            ),
            subtitle: Text(
              deTai.tenDeTai,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
              maxLines: 2,
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Thông báo'),
                    content: Text('Bạn chọn ${deTai.tenDeTai}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const Divider(
            color: Colors.black,
            height: 5,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Chuyên ngành: ${deTai.noiDung}',
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0, bottom: 8.0),
            child: Text(
              'Giáo viên: ${deTai.tenGiangVien}',
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}