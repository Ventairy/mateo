import * as mateoBabel from '@babel/types';
import svgr from 'vite-plugin-svgr';

/** Shared by builds and tests; the foundation SVGs remain the artwork source. */
export function createMateoIconSvgPlugin() {
  return svgr({
    svgrOptions: {
      jsxRuntime: 'automatic',
      svgo: false,
      expandProps: false,
      template: ({ componentName, jsx }, { tpl }) => {
        // BaseMateoIcon owns the SVG frame. Keep authored children and geometry intact.
        mateoBabel.traverseFast(jsx, (node) => {
          if (
            !mateoBabel.isJSXAttribute(node) ||
            !mateoBabel.isJSXIdentifier(node.name) ||
            !mateoBabel.isStringLiteral(node.value)
          ) {
            return;
          }
          const value = node.value.value;
          if (node.name.name === 'id') {
            node.value = mateoBabel.jsxExpressionContainer(
              mateoBabel.binaryExpression(
                '+',
                mateoBabel.identifier('idPrefix'),
                mateoBabel.stringLiteral(`-${value}`),
              ),
            );
          } else if (value.startsWith('url(#') && value.endsWith(')')) {
            node.value = mateoBabel.jsxExpressionContainer(
              mateoBabel.binaryExpression(
                '+',
                mateoBabel.binaryExpression(
                  '+',
                  mateoBabel.stringLiteral('url(#'),
                  mateoBabel.identifier('idPrefix'),
                ),
                mateoBabel.stringLiteral(`-${value.slice(5)}`),
              ),
            );
          }
        });
        const artwork = mateoBabel.jsxFragment(
          mateoBabel.jsxOpeningFragment(),
          mateoBabel.jsxClosingFragment(),
          jsx.children,
        );
        return tpl`
          const ${componentName} = ({ idPrefix }) => ${artwork};
          export default ${componentName};
        `;
      },
    },
  });
}
