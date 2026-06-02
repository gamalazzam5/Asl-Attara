import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/text_style.dart';
import '../manger/cubits/category_cubit.dart';
import '../manger/cubits/category_state.dart';
import '../widgets/categories_grid.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  void addCategory() {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();
    String selectedColor = '#D4F1E4';
    final categoryCubit = context.read<CategoryCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'إضافة قسم جديد',
                      style: TextStyles.text18.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: controller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'أدخل اسم القسم';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'اسم القسم',
                        prefixIcon: const Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          const [
                            '#D4F1E4',
                            '#FFF3E0',
                            '#E8EAF6',
                            '#FCE4EC',
                          ].map((color) {
                            return GestureDetector(
                              onTap: () =>
                                  setModal(() => selectedColor = color),
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: Color(
                                    int.parse(
                                      '0xFF${color.replaceAll('#', '')}',
                                    ),
                                  ),
                                  shape: BoxShape.circle,
                                  border: selectedColor == color
                                      ? Border.all(
                                          width: 3,
                                          color: AppColors.primaryColor,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 25.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        final added = await categoryCubit.addCategory(
                          title: controller.text,
                          color: selectedColor,
                        );

                        if (!context.mounted || !mounted) return;

                        Navigator.pop(context);

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            backgroundColor: added
                                ? AppColors.primaryColor
                                : AppColors.errorColor,
                            content: Text(
                              added
                                  ? 'تم إضافة القسم بنجاح'
                                  : 'القسم موجود بالفعل',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'إضافة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        heroTag: 'categories_fab',
        backgroundColor: AppColors.primaryColor,
        onPressed: addCategory,
        child: Icon(Icons.add, size: 28.r, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryLoaded) {
              return Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    Text(
                      'الأقسام',
                      style: TextStyles.text22.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: CategoriesGrid(categories: state.categories),
                    ),
                  ],
                ),
              );
            }

            if (state is CategoryError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
