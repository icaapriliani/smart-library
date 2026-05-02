import 'package:flutter/material.dart';
import '../models/book.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
          color: Colors.grey.withOpacity(0.08), blurRadius: 15,  offset: const Offset(0, 5), 
      ),
          ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              book.image,
              width: 70,
              height: 95,
              fit: BoxFit.cover,
            ),
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
                    Expanded(child: 
                  Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                
                overflow:TextOverflow.ellipsis,
                    ),),
                    const Icon( Icons.more_vert, color: Colors.grey, size: 18,),
              ],
            ),
            const SizedBox(height: 4),
                Text(book.author, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                //kategori
                Text(
                  book.category,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                //status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        book.status,
                        style: TextStyle(color: getStatusColor(), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),

                    Icon(
                      Icons.bookmark_border, color: Colors.grey.shade400,
                    )

                ],),
                const SizedBox(height: 10),

                //progress
                Row(
                  
                  children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: book.progress / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        color: book.status == "Done" ? Colors.green : Colors.deepPurple,
                      ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  
                    Text("${book.progress}%", style: const TextStyle(fontSize: 12, color: Colors.grey),
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
       
            
