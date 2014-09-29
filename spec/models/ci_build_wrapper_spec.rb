require 'spec_helper'

describe CiBuildWrapper do
  let(:build)    { double(native: double(getChangeSet: changeset), result: 'SUCCESS') }
  let(:launcher) { double }
  let(:listener) { double }
  let(:wrapper)  { CiBuildWrapper.new({'build_text' => ' *build* '}) }

  describe '#setup' do
    context 'when changeset is empty' do
      let(:changeset) { double(isEmptySet: true) }

      it 'should get back to normal build' do
        expect(listener).to receive(:info).with('Empty changeset (manual trigger?), running build.')
        wrapper.setup(build, launcher, listener)
      end
    end

    context 'when changeset is not empty' do
      context 'when message includes [ci build]' do
        let(:changeset) {
          double(isEmptySet: false, getLogs:
            double(size: 1, get:
              double(getComment: 'foobar [ci build]', getCommitId: 'b2bb7ab')
            )
          )
        }

        it 'should skip build' do
          allow(wrapper).to receive(:halt) { build }
          expect(listener).to receive(:info).with('Message: foobar [ci build]')
          expect(listener).to receive(:info).with('Commit: b2bb7ab')
          expect(listener).to receive(:info).with('Text did not contain [ci *build*]. Skipping build.')
          wrapper.setup(build, launcher, listener)
        end
      end

      context 'when message includes [ci   *build*]' do
        let(:changeset) {
          double(isEmptySet: false, getLogs:
            double(size: 1, get:
              double(getComment: 'foobar [ci   *build*]', getCommitId: 'b2bb7ab')
            )
          )
        }

        it 'should get back to normal build' do
          expect(listener).to receive(:info).with('Built by commit message.')
          wrapper.setup(build, launcher, listener)
        end
      end

      context 'when raise an error' do
        let(:changeset) {
          double(isEmptySet: false, getLogs:
            double(size: 1, get:
              double(getCommitId: 'b2bb7ab')
            )
          )
        }

        it 'should get back to normal build' do
          allow(changeset.getLogs.get).to receive(:getComment).and_raise
          expect(listener).to receive(:error).twice
          wrapper.setup(build, launcher, listener)
        end
      end
    end
  end
end
