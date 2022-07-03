import {readFileData} from '../recordAddress';

test('readFileData', () => {
    const r = readFileData('bsctest');
    console.log(r.aaa.address);
});