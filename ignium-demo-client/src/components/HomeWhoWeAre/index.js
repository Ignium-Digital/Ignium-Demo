import React from 'react';
import { Text, Link, Image } from '@sitecore-jss/sitecore-jss-react';
import ContainerTwoColumn from '../ContainerTwoColumn';

const HomeWhoWeAre = ({ fields }) => (
  <div>
    <ContainerTwoColumn>
      <div>
        <Text tag="h3" field={fields.heading} />
        <Text field={fields.content} />
        <Link field={fields.link} />
      </div>
      <div>
        <Image media={fields.image} />
      </div>
    </ContainerTwoColumn>
  </div>
);

export default HomeWhoWeAre;
