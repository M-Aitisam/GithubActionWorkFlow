
const chai = require('chai');
const chaiHttp = require('chai-http');
const app = require('../app');

chai.use(chaiHttp);
const expect = chai.expect;

describe('Restaurant App', () => {
  it('should return 200 status for homepage', (done) => {
    chai.request(app)
      .get('/')
      .end((err, res) => {
        expect(res).to.have.status(200);
        done();
      });
  });

  it('should have restaurant name in response', (done) => {
    chai.request(app)
      .get('/')
      .end((err, res) => {
        expect(res.text).to.include('Gourmet Box');
        done();
      });
  });
});