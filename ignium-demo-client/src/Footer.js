/*
 * Function imports
 */

import React from 'react';
import PropTypes from 'prop-types';

/*
 * Component imports
 */

import { NavLink } from 'react-router-dom';

/*
 * Image/SVG imports
 */

import FooterLogo from './assets/SVG/FooterLogo';
import TwitterLogo from './assets/SVG/social/TwitterLogo';
import LinkedInLogo from './assets/SVG/social/LinkedInLogo';
import EmailLogo from './assets/SVG/social/EmailLogo';

import './assets/footer.css';

const Footer = (props) => {
  const { className } = props;

  return (
    <footer className={className}>
      <div className={`${className}__footer__logo`}>
        <span className={`${className}__footer__line`} />
        <FooterLogo />
        <span className={`${className}__footer__line`} />
      </div>
      <div className={`${className}__social__icons`}>
        <a href="https://www.twitter.com/IgniumDigital" target="_blank" rel="noopener noreferrer">
          <TwitterLogo />
        </a>
        <a
          href="https://www.linkedin.com/company/ignium-digital"
          target="_blank"
          rel="noopener noreferrer"
        >
          <LinkedInLogo />
        </a>
        <a href="mailto:hello@igniumdigital.com" target="_blank" rel="noopener noreferrer">
          <EmailLogo />
        </a>
      </div>
      <nav className={`${className}__links`}>
        <ul>
          <li>
            <NavLink to="/who-we-are">Who We Are</NavLink>
          </li>
          <li>
            <NavLink to="/services">Services</NavLink>
          </li>
          <li>
            <NavLink to="/insights">Insights</NavLink>
          </li>
          <li>
            <NavLink to="/careers">Careers</NavLink>
          </li>
          <li>
            <NavLink to="/contact">Contact Us</NavLink>
          </li>
        </ul>
      </nav>
      <p>© Ignium Digital, LLC. 2020, All Rights Reserved</p>
    </footer>
  );
};

Footer.defaultProps = {
  className: 'footer',
};

Footer.propTypes = {
  className: PropTypes.string,
};

export default Footer;
