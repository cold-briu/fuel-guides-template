import { cssObj } from '@fuel-ui/css';
import { Flex, Icon, Text } from '@fuel-ui/react';
import Link from 'next/link';

import type { DocType } from '~/src/types';

type BreadcrumbProps = {
  doc: DocType;
};

export function Breadcrumb({ doc }: BreadcrumbProps) {
  return (
    <Flex css={styles.root}>
      <Text as="span" rightIcon={Icon.is('CaretRight')}>
        <Link href="/">Docs</Link>
      </Text>
      {doc.category && (
        <Text as="span" rightIcon={Icon.is('CaretRight')}>
          <Link href={`/docs/${doc.category.toLowerCase().replace(/\s+/g, '-')}`}>{doc.category}</Link>
        </Text>
      )}
      <Text as="span">{doc.title}</Text>
    </Flex>
  );
}

const styles = {
  root: cssObj({
    alignItems: 'center',
    gap: '$2',

    span: {
      color: '$gray8',
      fontSize: '$sm',
    },
    '& > span:last-of-type': {
      color: '$gray10',
    },
  }),
};
