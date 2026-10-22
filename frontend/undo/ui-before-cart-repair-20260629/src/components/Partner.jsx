import { useEffect, useRef, useState } from 'react';

function Partner() {
    const [isVisible, setIsVisible] = useState(false);
    const ref = useRef();

    useEffect(() => {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    setIsVisible(true);
                    observer.disconnect();
                }
            });
        });
        if (ref.current) observer.observe(ref.current);
        return () => observer.disconnect();
    }, []);

    const revealStyle = {
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'translateY(0)' : 'translateY(30px)',
        transition: 'opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1), transform 0.8s cubic-bezier(0.16, 1, 0.3, 1)'
    };

    return (
        <div 
            ref={ref} 
            className="partner-card" 
            id="partner" 
            style={revealStyle}
        >
            <img 
                src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" 
                alt="Partner Icon" 
                style={{ width: '60px', height: '60px' }} 
            />
            <h2>Partner With Us & Expand Your Reach</h2>
            <div className="partner-content">
                <p>Take your local business to new heights by partnering with Anywhere. We help you reach more customers in your neighborhood effortlessly.</p>
                <ul className="partner-list">
                    <li>🚀 <strong>Boost Your Sales:</strong> Tap into a larger local customer base and see your orders grow.</li>
                    <li>📦 <strong>Hassle-Free Logistics:</strong> Let us handle the deliveries while you focus on cooking or stocking.</li>
                    <li>🤝 <strong>Trusted Delivery Fleet:</strong> Our reliable and professional team ensures your items reach safely.</li>
                </ul>
                <p style={{ fontWeight: '600', marginTop: '20px' }}>
                    Ready to grow? Contact us today to become a partner: 98765 43210
                </p>
            </div>
        </div>
    );
}

export default Partner;