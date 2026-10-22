import { useEffect, useState } from "react";
import "./Orders.css";

const STEPS = ["PLACED", "CONFIRMED", "OUT_FOR_DELIVERY", "DELIVERED"];
const readable = (value = "PLACED") => value.replaceAll("_", " ").toLowerCase().replace(/\b\w/g, (l) => l.toUpperCase());

function Orders({ onBack, onTrackOrder }) {
    const user = JSON.parse(localStorage.getItem("user"));
    const [orders, setOrders] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    useEffect(() => {
        if (!user?.id) { setLoading(false); return; }
        fetch(`http://localhost:8080/api/orders/user/${user.id}`)
            .then(r => { if (!r.ok) throw new Error(); return r.json(); })
            .then(setOrders)
            .catch(() => setError("Unable to load your orders."))
            .finally(() => setLoading(false));
    }, [user?.id]);

    return (
        <main className="orders-page">
            <nav className="orders-nav"><button onClick={onBack}>Back</button><strong>Anywhere Orders</strong><span>{orders.length} orders</span></nav>
            <div className="orders-shell">
                <header><span>Your deliveries</span><h1>Order history</h1><p>Track every order from confirmation to your doorstep.</p></header>
                {loading && <div className="orders-state">Loading orders...</div>}
                {error && <div className="orders-state error">{error}</div>}
                {!loading && !error && !orders.length && <div className="orders-state">No orders yet.</div>}
                <div className="orders-list">
                    {orders.map((order) => {
                        const status = order.status || "PLACED";
                        const activeStep = STEPS.indexOf(status);
                        return (
                            <article className="order-row" key={order.id}>
                                <div className="order-top">
                                    <div><span>Order #{order.id}</span><strong>{new Date(order.orderedAt).toLocaleString()}</strong></div>
                                    <span className={`order-status status-${status.toLowerCase()}`}><i></i>{readable(status)}</span>
                                </div>
                                <div className="order-body">
                                    <div className="order-products">{order.items.map((item) => <p key={item.id}><span>{item.quantity} x {item.productName}</span><strong>₹{Number(item.subtotal).toFixed(2)}</strong></p>)}</div>
                                    <div className="order-meta"><span>Deliver to</span><p>{order.deliveryAddress}</p><span>Payment</span><p>{readable(order.paymentMethod)}</p></div>
                                </div>
                                {status !== "CANCELLED" && (
                                    <div className="order-track">
                                        {STEPS.map((step, index) => (
                                            <div className={index <= activeStep ? "done" : ""} key={step}><i></i><span>{readable(step)}</span></div>
                                        ))}
                                    </div>
                                )}
                                <div className="order-footer">
                                    <div className="order-total"><span>Total paid</span><strong>₹{Number(order.totalAmount).toFixed(2)}</strong></div>
                                    {status !== "CANCELLED" && status !== "DELIVERED" && (
                                        <button className="track-btn" onClick={() => onTrackOrder(order.id)}>🛵 Track Order</button>
                                    )}
                                </div>
                            </article>
                        );
                    })}
                </div>
            </div>
        </main>
    );
}

export default Orders;