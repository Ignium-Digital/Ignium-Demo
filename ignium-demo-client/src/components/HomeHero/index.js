import React from 'react';
import { Text, RichText, Image, Link } from '@sitecore-jss/sitecore-jss-react';
import './HomeHero.css';
import ContainerTwoColumn from '../ContainerTwoColumn';

/**
 * A simple Content Block component, with a heading and rich text block.
 * This is the most basic building block of a content site, and the most basic
 * JSS component that's useful.
 */
const HomeHero = ({ fields }) => (
  <div className="home-hero">
    <ContainerTwoColumn>
      <div className="home-hero-text">
        <Text tag="h2" className="home-hero-heading" field={fields.heading} />
        <RichText className="home-hero-subheading" field={fields.subheading} />
        <Link className="home-hero-action" field={fields.link} />
      </div>
      <div className="home-hero-image">
        <Image media={fields.image} />
      </div>
    </ContainerTwoColumn>
  </div>
);

export default HomeHero;
