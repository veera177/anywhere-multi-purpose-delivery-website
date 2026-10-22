import { useEffect, useRef, useState } from 'react';

function WhyChooseUs() {
    const [isVisible, setIsVisible] = useState(false);
    const ref = useRef();

    useEffect(() => {
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        setIsVisible(true);
                        observer.disconnect();
                    }
                });
            },
            { threshold: 0.2 }
        );
        if (ref.current) observer.observe(ref.current);
        return () => observer.disconnect();
    }, []);

    const stats = [
        { icon: '⚡', number: '30 min', label: 'Average Delivery Time' },
        { icon: '📦', number: '10,000+', label: 'Orders Delivered' },
        { icon: '⭐', number: '4.8/5', label: 'Customer Rating' },
        { icon: '🏪', number: '500+', label: 'Partner Stores' },
    ];

    return (
        <section className="why-choose-us" id="why-choose-us" ref={ref}>
            <h2>Why Customers Trust Anywhere</h2>
            <p className="why-subtitle">Numbers that speak for our reliability</p>
            <div className={`stats-grid ${isVisible ? 'stats-visible' : ''}`}>
                {stats.map((stat, index) => (
                    <div
                        className="stat-card"
                        key={index}
                        style={{ transitionDelay: `${index * 120}ms` }}
                    >
                        <span className="stat-icon">{stat.icon}</span>
                        <span className="stat-number">{stat.number}</span>
                        <span className="stat-label">{stat.label}</span>
                    </div>
                ))}
            </div>
        </section>
    );
}

export default WhyChooseUs;
