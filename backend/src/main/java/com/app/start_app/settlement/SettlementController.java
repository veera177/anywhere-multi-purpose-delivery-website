package com.app.start_app.settlement;

import com.app.start_app.order.Order;
import com.app.start_app.order.OrderDAO;
import com.app.start_app.order.OrderItem;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

/**
 * POST /api/settlements/order/{orderId}
 *
 * Triggered after payment confirmation.  Reads the confirmed order from the
 * database, derives settlement inputs, calls SettlementService, and stores
 * the result.  Returns the settlement record.
 *
 * The deliveryFee passed in the request body is the amount already charged
 * to the customer (which must equal the amount on the payment).
 */
@RestController
@CrossOrigin(origins = "*")
public class SettlementController {

    private final SettlementService settlementService;
    private final SettlementDAO     settlementDAO;
    private final OrderDAO          orderDAO;

    public SettlementController(SettlementService settlementService,
                                SettlementDAO settlementDAO,
                                OrderDAO orderDAO) {
        this.settlementService = settlementService;
        this.settlementDAO     = settlementDAO;
        this.orderDAO          = orderDAO;
    }

    @PostMapping("/api/settlements/order/{orderId}")
    public ResponseEntity<?> settle(@PathVariable Integer orderId,
                                    @RequestBody SettlementTriggerRequest body) {
        // Idempotent: skip if already settled
        if (settlementDAO.findByOrderId(orderId) != null) {
            return ResponseEntity.ok(settlementDAO.findByOrderId(orderId));
        }

        Order order = orderDAO.findById(orderId);
        if (order == null) {
            return ResponseEntity.notFound().build();
        }

        List<OrderItem> items = order.getItems();
        if (items == null || items.isEmpty()) {
            return ResponseEntity.badRequest().body("Order has no items");
        }

        String serviceType = items.get(0).getServiceType();

        BigDecimal itemTotal = items.stream()
                .map(i -> i.getPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal deliveryFee = body.getDeliveryFee() != null
                ? body.getDeliveryFee()
                : BigDecimal.ZERO;

        List<Boolean> prescriptionFlags = items.stream()
                .map(i -> Boolean.TRUE.equals(i.getPrescriptionRequired()))
                .collect(Collectors.toList());

        SettlementRequest req = new SettlementRequest();
        req.setOrderId(orderId);
        req.setServiceType(serviceType);
        req.setItemTotal(itemTotal);
        req.setDeliveryFee(deliveryFee);
        req.setItemPrescriptionFlags(prescriptionFlags);

        SettlementRecord record = settlementService.settle(req);
        return ResponseEntity.ok(record);
    }

    @GetMapping("/api/settlements/order/{orderId}")
    public ResponseEntity<?> getSettlement(@PathVariable Integer orderId) {
        SettlementRecord record = settlementDAO.findByOrderId(orderId);
        return record != null ? ResponseEntity.ok(record) : ResponseEntity.notFound().build();
    }
}
