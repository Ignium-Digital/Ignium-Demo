import React from 'react';
import { Text, Link } from '@sitecore-jss/sitecore-jss-react';
import './HomeServices.css';

const HomeServices = (props) => {
  const { services } = props.fields;

  return (
    <div className="services-container">
      <Text className="services-heading" tag="h2" field={props.fields.heading} />
      <div className="services-content">
        <ul className="services-list">
          {services &&
            services.map((service, index) => (
              <li key={index} className="services-list-item">
                <Text field={service.fields.textField} />
              </li>
            ))}
        </ul>
        <Link className="services-action" field={props.fields.link} />
      </div>
    </div>
  );
};

export default HomeServices;
