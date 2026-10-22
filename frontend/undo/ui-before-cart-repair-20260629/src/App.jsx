import { useState, useEffect } from 'react';
import Navbar from "./components/Navbar.jsx";
import Content from "./components/Content.jsx";
import Services from "./components/Services.jsx";
import WhyChooseUs from "./components/WhyChooseUs.jsx";
import Partner from "./components/Partner.jsx";
import Contactus from "./components/Contactus.jsx";
import ScrollToTop from "./components/ScrollToTop.jsx";
import Sign from "./components/Sign.jsx";
import Register from "./components/Register.jsx";
import FoodDelivery from "./pages/FoodDelivery/FoodDelivery.jsx";
import GroceryDelivery from "./pages/GroceryDelivery/GroceryDelivery.jsx";
import MedicineDelivery from "./pages/MedicineDelivery/MedicineDelivery.jsx";
import CourierDelivery from "./pages/CourierDelivery/CourierDelivery.jsx";
import UserProfile from "./pages/UserProfile/UserProfile.jsx";
import Cart from "./pages/Cart/Cart.jsx";
import Checkout from "./pages/Checkout/Checkout.jsx";
import Orders from "./pages/Orders/Orders.jsx";
import TrackOrder from "./pages/TrackOrder/TrackOrder.jsx";


function App() {
  const [currentView, setCurrentView] = useState('home'); // 'home', 'signin', 'register'
  const [checkoutItems, setCheckoutItems] = useState([]);
  const [trackOrderId, setTrackOrderId] = useState(null);
  const [justPlaced, setJustPlaced] = useState(false);
  const [isDarkMode] = useState(() => {
    return localStorage.getItem('theme') === 'dark';
  });

  useEffect(() => {
    if (isDarkMode) {
      document.body.classList.add('dark-mode');
      localStorage.setItem('theme', 'dark');
    } else {
      document.body.classList.remove('dark-mode');
      localStorage.setItem('theme', 'light');
    }
  }, [isDarkMode]);

  return (
    <>
      {currentView === 'signin' && (
        <Sign 
          onBack={() => setCurrentView('home')} 
          onRegisterClick={() => setCurrentView('register')}
        />
      )}
      {currentView === 'register' && (
        <Register 
          onBack={() => setCurrentView('home')}
          onSignInClick={() => setCurrentView('signin')}
        />
      )}
      {currentView === 'food' && (
        <FoodDelivery
          onBack={() => setCurrentView('home')}
          onGoToCart={() => setCurrentView('cart')}
        />
      )}
      {currentView === 'grocery' && (
        <GroceryDelivery
          onBack={() => setCurrentView('home')}
          onGoToCart={() => setCurrentView('cart')}
        />
      )}
      {currentView === 'medicine' && (
        <MedicineDelivery
          onBack={() => setCurrentView('home')}
          onGoToCart={() => setCurrentView('cart')}
        />
      )}
      {currentView === 'courier' && (
        <CourierDelivery
          onBack={() => setCurrentView('home')}
          onOrderPlaced={(order) => {
            setTrackOrderId(order?.id ?? null);
            setJustPlaced(true);
            setCurrentView('track-order');
          }}
        />
      )}
      {currentView === 'profile' && (
        <UserProfile onBack={() => setCurrentView('home')} />
      )}
      {currentView === 'cart' && (
        <Cart 
          onBack={() => setCurrentView('home')}
          onSignInClick={() => setCurrentView('signin')}
          onCheckout={(items) => {
            setCheckoutItems(items);
            setCurrentView('checkout');
          }}
        />
      )}
      {currentView === 'checkout' && (
        <Checkout
          items={checkoutItems}
          onBack={() => setCurrentView('cart')}
          onOrderPlaced={(order) => {
            setTrackOrderId(order?.id ?? null);
            setJustPlaced(true);
            setCurrentView('track-order');
          }}
        />
      )}
      {currentView === 'track-order' && (
        <TrackOrder
          orderId={trackOrderId}
          justPlaced={justPlaced}
          onBack={() => {
            setJustPlaced(false);
            setCurrentView('orders');
          }}
          onReorderComplete={() => {
            setJustPlaced(false);
            setCurrentView('cart');
          }}
        />
      )}
      {currentView === 'orders' && (
        <Orders
          onBack={() => setCurrentView('home')}
          onTrackOrder={(orderId) => {
            setTrackOrderId(orderId);
            setCurrentView('track-order');
          }}
        />
      )}
      {currentView === 'home' && (
        <>
          <Navbar 
            onSignInClick={() => setCurrentView('signin')}
            onProfileClick={() => setCurrentView('profile')}
            onCartClick={() => setCurrentView('cart')}
            onOrdersClick={() => setCurrentView('orders')}
          />
          <main className="main-content">
            {/* 1. Hero Section */}
            <Content />

            {/* 2. Our Services */}
            <Services 
              onFoodOpen={() => setCurrentView('food')} 
              onGroceryOpen={() => setCurrentView('grocery')}
              onMedicineOpen={() => setCurrentView('medicine')}
              onCourierOpen={() => setCurrentView('courier')}
            />

            {/* 3. Trust Stats */}
            <WhyChooseUs />

            {/* 4. Partner Info - Full Width */}
            <section className="info-section">
              <Partner />
            </section>
          </main>

          {/* 7. Footer */}
          <Contactus />

          {/* Scroll to Top */}
          <ScrollToTop />
        </>
      )}
    </>
  );
}
export default App;
