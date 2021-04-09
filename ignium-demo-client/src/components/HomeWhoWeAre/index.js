import React from 'react';
import { Text, Link, Image } from '@sitecore-jss/sitecore-jss-react';

const HomeWhoWeAre = ({ fields }) => (
  <div>
    <Text tag="h3" field={fields.heading} />
    <Text field={fields.content} />
    <Link field={fields.link} />
    <Image media={fields.image} />
  </div>
);

export default HomeWhoWeAre;
