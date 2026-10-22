import { useEffect, useState } from "react";
import "./Checkout.css";
import OrderSuccessBanner from "../../components/OrderSuccessBanner.jsx";

const API_URL = "http://localhost:8080/api";

function Checkout({ items, onBack, onOrderPlaced }) {
    const user = JSON.parse(localStorage.getItem("user"));
    const [profileAddress, setProfileAddress] = useState(null);
    const [paymentMethod, setPaymentMethod] = useState("CASH_ON_DELIVERY");
    const [loading, setLoading] = useState(true);
    const [placing, setPlacing] = useState(false);
    const [orderPlaced, setOrderPlaced] = useState(false);
    const [placedOrderId, setPlacedOrderId] = useState(null);
    const [showBanner, setShowBanner] = useState(false);
    const [message, setMessage] = useState("");

    useEffect(() => {
        if (!user?.id) {
            setLoading(false);
            return;
        }

        fetch(`${API_URL}/users/${user.id}/profile`)
            .then((response) => {
                if (!response.ok) throw new Error("Address load failed");
                return response.json();
            })
            .then(setProfileAddress)
            .catch(() => setMessage("Unable to load your profile address."))
            .finally(() => setLoading(false));
    }, [user?.id]);

    const total = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

    const placeOrder = async () => {
        if (!profileAddress?.addressLine || !profileAddress?.town || !profileAddress?.district) {
            setMessage("Please complete your delivery address in Profile before ordering.");
            return;
        }

        setPlacing(true);
        setMessage("");

        try {
            const response = await fetch(`${API_URL}/orders`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    userId: user.id,
                    paymentMethod,
                    items: items.map((item) => ({
                        productId: item.productId,
                        serviceType: item.serviceType,
                        productName: item.productName,
                        price: item.price,
                        quantity: item.quantity,
                    })),
                }),
            });

            const data = await response.json();
            if (!response.ok) throw new Error(data.error || "Order placement failed");

            setOrderPlaced(true);
            setPlacedOrderId(data.id);
            setShowBanner(true);
            setMessage(`Order #${data.id} placed successfully`);

            setTimeout(() => onOrderPlaced(data), 1600);
        } catch (error) {
            setMessage(error.message);
        } finally {
            setPlacing(false);
        }
    };

    if (!user || !items.length) {
        return (
            <main className="checkout-page checkout-center">
                <h2>Your checkout session is empty</h2>
                <button onClick={onBack}>Return to cart</button>
            </main>
        );
    }

    return (
        <main className="checkout-page">
            <OrderSuccessBanner
                show={showBanner}
                userName={user?.fullName}
                orderId={placedOrderId}
                onClose={() => setShowBanner(false)}
            />

            <nav className="checkout-nav">
                <button onClick={onBack} aria-label="Back to cart">Back</button>
                <strong>Anywhere Checkout</strong>
                <span>Secure checkout</span>
            </nav>

            <div className="checkout-shell">
                <section className="checkout-main">
                    <header>
                        <span>Final step</span>
                        <h1>Complete your order</h1>
                    </header>

                    {orderPlaced && (
                        <div className="checkout-success-panel">
                            <div className="checkout-success-icon">✓</div>
                            <div>
                                <strong>Order placed!</strong>
                                <p>Your items are being prepared. You can track live status next.</p>
                            </div>
                        </div>
                    )}

                    <div className="checkout-section">
                        <div className="checkout-heading">
                            <span className="checkout-number">1</span>
                            <div><h2>Delivery address</h2><p>Select where this order should arrive</p></div>
                        </div>

                        {loading ? <p>Loading profile address...</p> : (
                            <div className="address-options">
                                {profileAddress?.addressLine ? (
                                    <div className="profile-delivery-address">
                                        <span className="address-check">&#10003;</span>
                                        <span>
                                            <strong>Profile delivery address</strong>
                                            <br/>
                                            {profileAddress.addressLine}
                                            {profileAddress.landmark && `, Near ${profileAddress.landmark}`}
                                            {`, ${profileAddress.town || ""}, ${profileAddress.district || ""}`}
                                        </span>
                                        <small>Using your saved profile address</small>
                                    </div>
                                ) : (
                                    <p>No complete profile address found. Open Profile and add it first.</p>
                                )}
                            </div>
                        )}
                    </div>

                    <div className="checkout-section">
                        <div className="checkout-heading">
                            <span className="checkout-number">2</span>
                            <div><h2>Payment method</h2><p>Choose your preferred payment option</p></div>
                        </div>
                        <div className="payment-options">
                            {[["CASH_ON_DELIVERY", "Cash on delivery"], ["UPI", "UPI payment"], ["CARD", "Credit or debit card"]].map(([value, label]) => (
                                <label className={paymentMethod === value ? "selected" : ""} key={value}>
                                    <input type="radio" name="payment" value={value} checked={paymentMethod === value} onChange={(event) => setPaymentMethod(event.target.value)} />
                                    <span>{label}</span>
                                </label>
                            ))}
                        </div>
                    </div>
                </section>

                <aside className="checkout-summary">
                    <h2>Order summary</h2>
                    <div className="checkout-items">
                        {items.map((item) => (
                            <div key={item.cartId}>
                                <span>{item.quantity} x {item.productName}</span>
                                <strong>₹{(item.price * item.quantity).toFixed(2)}</strong>
                            </div>
                        ))}
                    </div>
                    <div className="checkout-total"><span>Total</span><strong>₹{total.toFixed(2)}</strong></div>
                    {message && <p className={`checkout-message ${orderPlaced ? "success" : ""}`}>{message}</p>}
                    <button className={`place-order-btn ${orderPlaced ? "placed" : ""}`} onClick={placeOrder} disabled={placing || orderPlaced || loading || !profileAddress?.addressLine}>
                        <span className="place-order-icon">{orderPlaced ? "✓" : placing ? "..." : "→"}</span>
                        <span><small>{orderPlaced ? "Confirmed" : "Free doorstep delivery"}</small><strong>{orderPlaced ? "Order placed" : placing ? "Placing your order" : "Place order"}</strong></span>
                    </button>
                </aside>
            </div>
        </main>
    );
}

export default Checkout;
