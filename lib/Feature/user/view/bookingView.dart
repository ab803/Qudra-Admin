import 'package:admin_qudra/core/Styles/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/Models/bookingModel.dart';
import '../../Dashboard/widgets/Drawer.dart';
import '../viewModel/booking_cubit.dart';
import '../viewModel/booking_state.dart';

class BookingView extends StatefulWidget {

  final String? userId;
  final String? userName;

  const BookingView({super.key, this.userId, this.userName});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _statusFilters = [
    'All',
    'confirmed',
    'pending_payment',
    'failed',
  ];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<BookingCubit>();
    if (widget.userId != null) {
      cubit.loadUserBookings(widget.userId!);
    } else {
      cubit.loadAllBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: widget.userId == null ? QudraDrawer() : null,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: widget.userId == null
            ? IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        )
            : IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go("/users"),
        ),
        title: const Text(
          'Super Admin',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
          if (state is BookingActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    widget.userId != null
                        ? '${widget.userName ?? 'User'} Bookings'
                        : 'Bookings',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.userId != null
                        ? 'All service bookings made by this user.'
                        : 'Monitor and manage all bookings across the platform.',
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // Stats row (only when loaded)
                  if (state is BookingLoaded) ...[
                    _StatsRow(bookings: state.bookings),
                    const SizedBox(height: 24),
                  ],

                  // Status filter
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _StatusFilterRow(
                      filters: _statusFilters,
                      activeFilter: state is BookingLoaded
                          ? state.activeStatusFilter
                          : 'All',
                      onSelected: (f) =>
                          context.read<BookingCubit>().filterByStatus(f),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Content
                  if (state is BookingLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child:
                        CircularProgressIndicator(color: Colors.black),
                      ),
                    )
                  else if (state is BookingLoaded) ...[
                    if (state.filtered.isEmpty)
                      _EmptyState(filter: state.activeStatusFilter)
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.filtered.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                        itemBuilder: (context, index) => BookingCard(
                          booking: state.filtered[index],
                          onDelete: () => context
                              .read<BookingCubit>()
                              .deleteBooking(state.filtered[index].id),
                        ),
                      ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final List<BookingModel> bookings;
  const _StatsRow({required this.bookings});

  @override
  Widget build(BuildContext context) {
    final total = bookings.length;
    final confirmed =
        bookings.where((b) => b.bookingStatus == 'confirmed').length;
    final pending =
        bookings.where((b) => b.bookingStatus == 'pending_payment').length;
    final failed =
        bookings.where((b) => b.bookingStatus == 'failed').length;

    return Row(
      children: [
        _StatChip(label: 'Total', value: '$total', color: Colors.black87),
        const SizedBox(width: 12),
        _StatChip(
            label: 'Confirmed',
            value: '$confirmed',
            color: Colors.green.shade700),
        const SizedBox(width: 12),
        _StatChip(
            label: 'Pending',
            value: '$pending',
            color: Colors.orange.shade700),
        const SizedBox(width: 12),
        _StatChip(
            label: 'Failed', value: '$failed', color: Colors.red.shade700),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w900, color: color),
            ),
            const SizedBox(height: 4),
            Text(label,
                style:
                const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

// ─── Status Filter Row ────────────────────────────────────────────────────────
class _StatusFilterRow extends StatelessWidget {
  final List<String> filters;
  final String activeFilter;
  final ValueChanged<String> onSelected;

  const _StatusFilterRow({
    required this.filters,
    required this.activeFilter,
    required this.onSelected,
  });

  String _label(String f) {
    switch (f) {
      case 'pending_payment':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'failed':
        return 'Failed';
      case 'success':
        return 'Success';
      default:
        return f;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Status:',
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((f) {
                final isSelected = f == activeFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onSelected(f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                        isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        _label(f),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.calendar_today_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              filter == 'All'
                  ? 'No bookings found'
                  : 'No "$filter" bookings',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Booking Card ─────────────────────────────────────────────────────────────
class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onDelete;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Top accent bar by status
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: _statusColor(booking.bookingStatus),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Row 1: ID + status badge + menu
                Row(
                  children: [
                    Text(
                      booking.shortId,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _StatusBadge(status: booking.bookingStatus),
                    const Spacer(),
                    PopupMenuButton<String>(
                      color: AppColors.background,
                      icon:
                      const Icon(Icons.more_vert, color: Colors.grey),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _confirmDelete(context);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Row 2: Date & Time | Amount
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'DATE & TIME',
                        Text(
                          '${booking.formattedDate}  ${booking.formattedTime}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'AMOUNT',
                        Text(
                          booking.formattedAmount,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Row 3: Payment Method | Payment Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'PAYMENT METHOD',
                        Text(
                          _formatPaymentMethod(booking.paymentMethod),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'PAYMENT STATUS',
                        _PaymentStatusBadge(
                            status: booking.paymentStatus),
                      ),
                    ),
                  ],
                ),

                // Notes (if present)
                if (booking.notes != null &&
                    booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildInfoItem(
                    'NOTES',
                    Text(
                      booking.notes!,
                      style: TextStyle(
                          color: Colors.grey.shade700, height: 1.4),
                    ),
                  ),
                ],

                // Confirmed/Cancelled timestamps
                if (booking.confirmedAt != null ||
                    booking.cancelledAt != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (booking.confirmedAt != null)
                        Expanded(
                          child: _buildInfoItem(
                            'CONFIRMED AT',
                            Text(
                              _formatTimestamp(booking.confirmedAt!),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      if (booking.cancelledAt != null)
                        Expanded(
                          child: _buildInfoItem(
                            'CANCELLED AT',
                            Text(
                              _formatTimestamp(booking.cancelledAt!),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.red.shade700),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete booking?'),
        content: Text(
            'This will permanently remove booking ${booking.shortId} from the platform.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child:
            const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade500;
      case 'pending_payment':
        return Colors.orange.shade400;
      case 'failed':
        return Colors.red.shade400;
      case 'success':
        return Colors.blue.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  String _formatPaymentMethod(String? method) {
    switch (method) {
      case 'wallet':
        return 'Wallet';
      case 'card':
        return 'Card';
      case 'cash_at_institution':
        return 'Cash at Institution';
      default:
        return method ?? '—';
    }
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildInfoItem(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'confirmed':
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        label = 'Confirmed';
        break;
      case 'pending_payment':
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade700;
        label = 'Pending';
        break;
      case 'failed':
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        label = 'Failed';
        break;
      case 'success':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade700;
        label = 'Success';
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade700;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

// ─── Payment Status Badge ─────────────────────────────────────────────────────
class _PaymentStatusBadge extends StatelessWidget {
  final String? status;
  const _PaymentStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null) return const Text('—', style: TextStyle(color: Colors.black54));

    Color fg;
    switch (status!.toLowerCase()) {
      case 'success':
        fg = Colors.green.shade700;
        break;
      case 'pending':
        fg = Colors.orange.shade700;
        break;
      case 'failed':
        fg = Colors.red.shade700;
        break;
      case 'cash_due':
        fg = Colors.blue.shade700;
        break;
      default:
        fg = Colors.grey.shade700;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          status!,
          style: TextStyle(fontWeight: FontWeight.w500, color: fg, fontSize: 13),
        ),
      ],
    );
  }
}