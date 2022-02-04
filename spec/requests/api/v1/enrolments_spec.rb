require 'swagger_helper'

RSpec.describe 'api/v1/enrolments', type: :request do
  path '/api/v1/enrolments' do
    get('list enrolments') do
      tags 'Enrolments'
      security [bearer_auth: []]

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response '201', 'Authorized' do
        let(:Authorization) { "Bearer #{::Base64.strict_encode64('admin@admin.com:2435647')}" }
        run_test!
      end
      response '401', 'authentication failed' do
        let(:Authorization) { "Bearer #{::Base64.strict_encode64('bogus:bogus')}" }
        run_test!
      end
    end

    post('create enrolment') do
        tags 'Enrolments'
        consumes 'application/json'
        security [bearer_auth: []]
        parameter name: :enrolment, in: :body, schema: {
          type: :object,
          properties: {
            review: { type: :text },
            raiting: { type: :integer },
            course_id: { type: :integer }
          },
          required: %w[review raiting course_id]
        }
        response '201', 'enrolment created' do
            let(:enrolment) do
              { review: 'bababa bbababa', raiting: '2', course_id: 1}
            end
            run_test!
          end
    
          response '422', 'invalid request' do
            let(:enrolment) {  { review: 'bababa bbababa', raiting: '2' } }
            run_test!
          end
    
          response '201', 'successfully authenticated' do
            let(:Authorization) { "Bearer #{::Base64.strict_encode64('admin@admin.com:2435647')}" }
            run_test!
          end
    
          response '401', 'authentication failed' do
            let(:Authorization) { "Bearer #{::Base64.strict_encode64('bogus:bogus')}" }
            run_test!
          end
          response(200, 'successful') do
    
            after do |example|
              example.metadata[:response][:content] = {
                'application/json' => {
                  example: JSON.parse(response.body, symbolize_names: true)
                }
              }
            end
            run_test!
          end
        end
    end
end
