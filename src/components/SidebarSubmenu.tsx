import { cssObj, cx } from '@fuel-ui/css';
import { Button, Flex, Icon, List } from '@fuel-ui/react';
import { usePathname } from 'next/navigation';
import { useState } from 'react';

import { SidebarLink } from './SidebarLink';

import type { SidebarLinkItem } from '~/src/types';

interface SidebarSubmenuProps extends SidebarLinkItem {
  handleClick: () => void
}

export function SidebarSubmenu({
  label,
  submenu,
  subpath,
  handleClick
}: SidebarSubmenuProps) {
  const pathname = usePathname();
  const isActive = pathname?.startsWith(`/docs/${subpath}`);
  const [isOpened, setIsOpened] = useState(Boolean(isActive));

  function toggle() {
    setIsOpened((s) => !s);
  }

  return (
    <Flex css={styles.root}>
      <div style={{display: "flex", justifyContent: "space-between"}}>
        <SidebarLink handleClick={handleClick} item={{label, slug: label.replace(/\s+/g, '-').toLowerCase()}}/>
      <Button
        variant="link"
        rightIcon={isOpened ? Icon.is('CaretUp') : Icon.is('CaretDown')}
        onPress={toggle}
        className={cx({ active: isActive })}
        />
      </div>
      {isOpened && (
        <List>
          {submenu?.map((item) => {
            if(item.label.replace(/\s+/g, '-').toLowerCase() != subpath){
            return ( <List.Item
              key={item.slug}
              icon={Icon.is('ArrowRight')}
              iconSize={10}
              iconColor="gray6"
            >
              
              <SidebarLink handleClick={handleClick} item={item} />
            </List.Item>)}
          })}
        </List>
      )}
    </Flex>
  );
}

const styles = {
  root: cssObj({
    flexDirection: 'column',

    '.fuel_button': {
      padding: '$0',
      justifyContent: 'space-between',
      color: '$gray10',
      fontWeight: '$normal',
    },
    '.fuel_button:focus': {
      outline: 'none',
      color: '$gray12',
    },
    '.fuel_button.active': {
      color: '$gray12',
    },
    '.fuel_button:hover': {
      color: '$gray11',
      textDecoration: 'none',
    },

    '.fuel_list': {
      display: 'flex',
      flexDirection: 'column',
      gap: '$1',
      mt: '$2',
    },
    '.fuel_list-item': {
      gap: '$2',
    },
    '.fuel_list-item a': {
      flex: 1,
    },
  }),
};
