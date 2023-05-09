import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final BoxFit boxFit;

  const CustomImage({
    super.key,
    this.imageFile,
    this.imageUrl,
    // por padrao é cover
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: boxFit,
      );
    }
    if (imageUrl?.isNotEmpty == true) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        // se esta carregando a imagem mostramos um progress
        progressIndicatorBuilder: (_, __, progress) =>
            CircularProgressIndicator(
          value: progress.progress,
        ),
        errorWidget: (_, __, ___) => const Icon(Icons.error),
        fit: boxFit,
      );
    }
    return Container(
      color: Colors.grey,
    );
  }
}
