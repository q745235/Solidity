/* eslint-disable no-undef */
module.exports = {
    globals: {
        'ts-jest': {
            tsconfig: 'tsconfig.json'
        }
    },
    
    coverageDirectory: "/coverage",
    preset: 'ts-jest',
    testEnvironment: 'node',
    clearMocks: true,
    testRegex: "(/__tests__/.*|(\\.|/)(test|spec))\\.tsx?$",
};
