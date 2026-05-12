import 'package:flutter/material.dart';
import '../models/book.dart';
import 'dart:io';
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const BookCard({
    super.key,
    required this.book,
    this.onDelete,
    this.onEdit,
  });
  Color getStatusColor(){
    switch(book.status){
    case "Done":
        return Colors.green;
        case "Reading":
        return Colors.orange;
        default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 15,  
            offset: const Offset(0, 5), 
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: book.image.isEmpty
                ? Container(
                    width: 70,
                    height: 95,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(Icons.book, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  )
                : (book.image.startsWith("http")
                    ? Image.network(
                        book.image,
                        width: 70,
                        height: 95,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 95,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                    : Image.file(
                        File(book.image),
                        width: 70,
                        height: 95,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 95,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Icon(Icons.broken_image),
                        ),
                      )),
          ),
          const SizedBox(width: 14),
          //info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title+menu
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  book.author, 
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                //kategori
                Text(
                  book.category,
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                //rating
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < book.rating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      book.rating.toString(),
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                //status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor().withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          book.status,
                          style: TextStyle(color: getStatusColor(), fontSize: 11, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.bookmark_border, 
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    )
                  ],
                ),
                const SizedBox(height: 10),

                //progress
                Row(
                  
                  children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: book.progress / 100,
                        minHeight: 6,
                        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        color: book.status == "Done" ? Colors.green : Theme.of(context).colorScheme.primary,
                      ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  
                    Text("${book.progress}%", 
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
       
            
