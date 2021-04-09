// eslint-disable-next-line no-unused-vars
import { CommonFieldTypes, SitecoreIcon, Manifest } from '@sitecore-jss/sitecore-jss-manifest';

/**
 * Adds the HomeHero component to the disconnected manifest.
 * This function is invoked by convention (*.sitecore.js) when `jss manifest` is run.
 * @param {Manifest} manifest Manifest instance to add components to
 */

export default function (manifest) {
  manifest.addComponent({
    name: 'HomeHero',
    displayName: 'Home Hero',
    // totally optional, but fun
    icon: SitecoreIcon.DocumentText,
    fields: [
      { name: 'heading', type: CommonFieldTypes.SingleLineText },
      { name: 'subheading', type: CommonFieldTypes.RichText },
      { name: 'link', type: CommonFieldTypes.GeneralLink },
      { name: 'image', type: CommonFieldTypes.Image },
    ],
  });
};
